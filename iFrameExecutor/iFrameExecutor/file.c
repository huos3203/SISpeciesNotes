/*
 * buffered file I/O
 * Copyright (c) 2001 Fabrice Bellard
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include "libavutil/avstring.h"
#include "libavutil/internal.h"
#include "libavutil/opt.h"
#include "avformat.h"
#if HAVE_DIRENT_H
#include <dirent.h>
#endif
#include <fcntl.h>
#if HAVE_IO_H
#include <io.h>
#endif
#if HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/stat.h>
#include <stdlib.h>
#include "os_support.h"
#include "url.h"

/* Some systems may not have S_ISFIFO */
#ifndef S_ISFIFO
#  ifdef S_IFIFO
#    define S_ISFIFO(m) (((m) & S_IFMT) == S_IFIFO)
#  else
#    define S_ISFIFO(m) 0
#  endif
#endif

/* Not available in POSIX.1-1996 */
#ifndef S_ISLNK
#  ifdef S_IFLNK
#    define S_ISLNK(m) (((m) & S_IFLNK) == S_IFLNK)
#  else
#    define S_ISLNK(m) 0
#  endif
#endif

/* Not available in POSIX.1-1996 */
#ifndef S_ISSOCK
#  ifdef S_IFSOCK
#    define S_ISSOCK(m) (((m) & S_IFMT) == S_IFSOCK)
#  else
#    define S_ISSOCK(m) 0
#  endif
#endif

/* standard file protocol */

typedef struct FileContext {
    const AVClass *class;
    int fd;
    int trunc;
    int blocksize;
#if HAVE_DIRENT_H
    DIR *dir;
#endif
} FileContext;

static const AVOption file_options[] = {
    { "truncate", "truncate existing files on write", offsetof(FileContext, trunc), AV_OPT_TYPE_BOOL, { .i64 = 1 }, 0, 1, AV_OPT_FLAG_ENCODING_PARAM },
    { "blocksize", "set I/O operation maximum block size", offsetof(FileContext, blocksize), AV_OPT_TYPE_INT, { .i64 = INT_MAX }, 1, INT_MAX, AV_OPT_FLAG_ENCODING_PARAM },
    { NULL }
};

static const AVOption pipe_options[] = {
    { "blocksize", "set I/O operation maximum block size", offsetof(FileContext, blocksize), AV_OPT_TYPE_INT, { .i64 = INT_MAX }, 1, INT_MAX, AV_OPT_FLAG_ENCODING_PARAM },
    { NULL }
};

static const AVClass file_class = {
    .class_name = "file",
    .item_name  = av_default_item_name,
    .option     = file_options,
    .version    = LIBAVUTIL_VERSION_INT,
};

static const AVClass pipe_class = {
    .class_name = "pipe",
    .item_name  = av_default_item_name,
    .option     = pipe_options,
    .version    = LIBAVUTIL_VERSION_INT,
};


//-------------------------------------
//解密算法
//-------------------------------------

#include "pbb_key.h"
#include "SMS4.h"

#define KEY_LEN 16
#define format16_right(x) ( (x)%16 !=0 ? (x)+16-(x)%16 : (x) )
#define format16_left(x) ( (x)%16 !=0 ? (x)-(x)%16 : (x) )
#define min(x,y) ( (x)>(y) ? (y):(x) )

//unsigned char key_r[KEY_LEN + 1] = "";
//long long code_len_r = 0;
//long long offset_r = 0;   //第二次加密，文件头部的偏移量
//long long file_len_r = 0;
unsigned char key_r[KEY_LEN+1] = {45,35,92,-47,-58,-36,-20,49,-75,32,39,-86,15,7,-40,-88};
//long long code_len_r = 2030336;
//设置为0 ，表示明文查看
long long code_len_r = 0;
//long long code_len_r = 0;
long long offset_r = 0;   //第二次加密，文件头部的偏移量
long long file_len_r = 2030327;

//const unsigned char *path = "/storage/emulated/0/DCIM/0.log";

/*
 * 设置密钥和加密长度
 */
//void set_key_info(unsigned char* key, long long code_len,long long file_len,long long offset) {
//    //    unlink(path);
//    if (key) {
//        release_key(); //设置前线释放key_r和code_len_r以免影响后续判断
//        memcpy(key_r,key,KEY_LEN);
//        
//        code_len_r = format16_right(code_len); //有的时候加密长度不是16的倍数
//        offset_r = offset;
//        file_len_r = file_len;
//        
//        //        FILE* file = fopen(path,"a+");
//        //        fprintf(file,"set_key_info offset: %d  \n",offset);
//        //        fclose(file);
//        
//    } else {
//        release_key();
//    }
//}
//
//void release_key() {
//    if (key_r) {
//        memset(key_r, 0, KEY_LEN);
//    }
//    code_len_r = 0;
//    offset_r = 0;
//    file_len_r = 0;
//}
//
//
//
//////From Me
//static int file_read(URLContext *h, unsigned char *buf, int size) {
//    FileContext *c = h->priv_data;
//    int r;
//    const int fd = c->fd;
//    size = FFMIN(size, c->blocksize);
//
//    //    //我们的key中间可能含有"\0"结束符，所以不能以key的长度判断
//    //    //if(strlen(key)==KEY_LEN&&code_len_r>0)
//    //    if (code_len_r > 0) {
//    //        long long cur_pos = lseek(fd, 0, SEEK_CUR); //SEEK_CUR可以确定当前位置，还有一个tell函数也可以，但linux不支持
//    //
//    //        //二代加密算法导致的偏移量
//    //        if (cur_pos<offset_r) {
//    //            lseek(fd,offset_r,SEEK_SET);
//    //            cur_pos = offset_r;
//    //
//    ////            FILE* file = fopen(path,"a+");
//    ////            fprintf(file,"Read调整偏移量 offset: %d \n",offset_r);
//    ////            fclose(file);
//    //        }
//    //
//    //        // 有时候cur_pos是-1（加入long long 之后应该不会了）
//    //        if (cur_pos > code_len_r + offset_r || cur_pos < offset_r || size <= 0) {
//    //            r = read(fd, buf, size);
//    //            return (-1 == r) ? AVERROR(errno) : r;
//    //        }
//    //
//    //        /*二代算法V2*/
//    //        /*
//    //         * 我们的加密算法要求数据其实位置是16的倍数，加密长度是16的倍数。即左右节点都得是16的倍数
//    //         * 此处要保证左右节点包含buf的大小
//    //         */
//    //
//    //        //        FILE* file1 = fopen(path,"a+");
//    //        //        fprintf(file1,"Read之前 cur pos:%d   offset:%d  减去： %d \n", cur_pos, offset_r,(cur_pos - offset_r)%16);
//    //        //        fclose(file1);
//    //
//    //        /* 第一步：读取加密数据（code_left+code_size），包含播放器需要的数据（cur_pos+size） */
//    //        const int code_offset = (cur_pos - offset_r) % 16;
//    //        const long long code_left = cur_pos - code_offset; //左边界，包含播放器所需数据
//    //        const int code_size = format16_right(size + code_offset);    //读取量，大于播放器需要的数目
//    //
//    ////        FILE* file = fopen(path,"a+");
//    ////        fprintf(file,"Read cur pos:%d   offset_r: %d  file_en %d \n", cur_pos,offset_r,file_len_r);
//    ////        fclose(file);
//    //
//    //        unsigned char* code_buf = (unsigned char*) malloc(code_size);
//    //
//    //        lseek(fd, code_left, SEEK_SET); //移动，准备读密文
//    //        int real_read = read(fd, code_buf, code_size);
//    //
//    //        int code_len = 0;   //读取数据的密文长度
//    //        if (code_len_r + offset_r >= code_left + real_read) {
//    //            code_len = real_read; //读到的全是密文
//    //        } else {
//    //            code_len = code_len_r + offset_r - code_left; //一部分是密文，那么code_len就等于这“一部分”的大小
//    //        }
//    //
//    //        SMS4SetKey((uint32*) key_r, 1);
//    //        SMS4Decrypt((uint32*) code_buf, (int)format16_right(code_len)); //注意，再确认下，length是16倍数
//    //
//    //        const int valid_read = FFMIN(size,real_read-code_offset);   //供给播放器的数据大小
//    //        memcpy(buf, code_buf + code_offset, valid_read);
//    //        lseek(fd, cur_pos + valid_read, SEEK_SET); //这个是必须的。还原到和直接调用read(fd, buf, size)一样的效果
//    //        free(code_buf);
//    //        r = valid_read;
//    //    } else {
//    //        r = read(c->fd, buf, size);
//    //    }
//    //
//    //    return (-1 == r) ? AVERROR(errno) : r;
//
//    //    //我们的key中间可能含有"\0"结束符，所以不能以key的长度判断
//    //    //if(strlen(key)==KEY_LEN&&code_len_r>0)
//    if (code_len_r > 0) {
//        long long cur_pos = lseek(fd, 0, SEEK_CUR); //SEEK_CUR可以确定当前位置，还有一个tell函数也可以，但linux不支持
//
//        if (cur_pos<offset_r) {
//            lseek(fd,offset_r,SEEK_SET);
//            cur_pos = offset_r;
//
//            //                    FILE* file = fopen(path,"a+");
//            //                    fprintf(file,"Read调整偏移量 offset: %d \n",offset_r);
//            //                    fclose(file);
//        }
//
//        // 有时候cur_pos是-1（加入long long 之后应该不会了）
//        if (cur_pos > code_len_r + offset_r || cur_pos < 0) {
//            r = read(fd, buf, size);
//            return (-1 == r) ? AVERROR(errno) : r;
//        }
//
//        /*
//         * 我们的加密算法要求数据其实位置是16的倍数，加密长度是16的倍数。即左右节点都得是16的倍数
//         * 此处要保证左右节点包含buf的大小
//         */
//        //        long long left_pos = format16_left(cur_pos);
//        //        long long right_pos = format16_right(cur_pos + size);
//        long long left_pos = cur_pos - (cur_pos - offset_r)%16;
//        long long right_pos = format16_right(cur_pos + size - offset_r) + offset_r;
//
//        int size_tmp = right_pos - left_pos;
//
//        unsigned char* buf_tmp = (unsigned char*) malloc(size_tmp);
//        lseek(fd, left_pos, SEEK_SET);
//        int read_tmp = read(fd, buf_tmp, size_tmp); //注意：read_tmp<=size_tmp，后面的判断就是因为这个原因
//
//        const long long cur_pos_now = left_pos + read_tmp; //现在流所处的实际位置，要区别cur_pos
//        int code_len = 0;
//        if (code_len_r + offset_r > cur_pos_now) {
//            code_len = read_tmp; //读到的全是密文
//        } else {
//            code_len = code_len_r + offset_r - left_pos; //一部分是密文，那么code_len就等于这“一部分”的大小
//        }
//
//        SMS4SetKey((uint32*) key_r, 1);
//        SMS4Decrypt((uint32*) buf_tmp, code_len);
//
//        const int left_offset = cur_pos - left_pos;
//        //valid_read即播放器实际需要的数据（<=size)
//        const int valid_read =
//        read_tmp - left_offset < size ? read_tmp - left_offset : size; //去掉因加密规则而format的那些数据
//
//        memcpy(buf, buf_tmp + left_offset, valid_read);
//        free(buf_tmp);
//        lseek(fd, cur_pos + valid_read, SEEK_SET); //这个是必须的。还原到和直接调用read(fd, buf, size)一样的效果
//
//        r = valid_read;
//        return (-1 == r) ? AVERROR(errno) : r;
//
//    } else {
//        r = read(fd, buf, size);
//        return (-1 == r) ? AVERROR(errno) : r;
//    }
//
//}



static int file_read(URLContext *h, unsigned char *buf, int size)
{
    FileContext *c = h->priv_data;
    int ret;
    size = FFMIN(size, c->blocksize);
    ret = read(c->fd, buf, size);
    return (ret == -1) ? AVERROR(errno) : ret;
}

static int file_write(URLContext *h, const unsigned char *buf, int size)
{
    FileContext *c = h->priv_data;
    int ret;
    size = FFMIN(size, c->blocksize);
    ret = write(c->fd, buf, size);
    return (ret == -1) ? AVERROR(errno) : ret;
}

static int file_get_handle(URLContext *h)
{
    FileContext *c = h->priv_data;
    return c->fd;
}

static int file_check(URLContext *h, int mask)
{
    int ret = 0;
    const char *filename = h->filename;
    av_strstart(filename, "file:", &filename);

    {
#if HAVE_ACCESS && defined(R_OK)
    if (access(filename, F_OK) < 0)
        return AVERROR(errno);
    if (mask&AVIO_FLAG_READ)
        if (access(filename, R_OK) >= 0)
            ret |= AVIO_FLAG_READ;
    if (mask&AVIO_FLAG_WRITE)
        if (access(filename, W_OK) >= 0)
            ret |= AVIO_FLAG_WRITE;
#else
    struct stat st;
    ret = stat(filename, &st);
    if (ret < 0)
        return AVERROR(errno);

    ret |= st.st_mode&S_IRUSR ? mask&AVIO_FLAG_READ  : 0;
    ret |= st.st_mode&S_IWUSR ? mask&AVIO_FLAG_WRITE : 0;
#endif
    }
    return ret;
}

static int file_delete(URLContext *h)
{
#if HAVE_UNISTD_H
    int ret;
    const char *filename = h->filename;
    av_strstart(filename, "file:", &filename);

    ret = rmdir(filename);
    if (ret < 0 && errno == ENOTDIR)
        ret = unlink(filename);
    if (ret < 0)
        return AVERROR(errno);

    return ret;
#else
    return AVERROR(ENOSYS);
#endif /* HAVE_UNISTD_H */
}

static int file_move(URLContext *h_src, URLContext *h_dst)
{
#if HAVE_UNISTD_H
    const char *filename_src = h_src->filename;
    const char *filename_dst = h_dst->filename;
    av_strstart(filename_src, "file:", &filename_src);
    av_strstart(filename_dst, "file:", &filename_dst);

    if (rename(filename_src, filename_dst) < 0)
        return AVERROR(errno);

    return 0;
#else
    return AVERROR(ENOSYS);
#endif /* HAVE_UNISTD_H */
}

#if CONFIG_FILE_PROTOCOL

static int file_open(URLContext *h, const char *filename, int flags)
{
    FileContext *c = h->priv_data;
    int access;
    int fd;
    struct stat st;

    av_strstart(filename, "file:", &filename);

    if (flags & AVIO_FLAG_WRITE && flags & AVIO_FLAG_READ) {
        access = O_CREAT | O_RDWR;
        if (c->trunc)
            access |= O_TRUNC;
    } else if (flags & AVIO_FLAG_WRITE) {
        access = O_CREAT | O_WRONLY;
        if (c->trunc)
            access |= O_TRUNC;
    } else {
        access = O_RDONLY;
    }
#ifdef O_BINARY
    access |= O_BINARY;
#endif
    fd = avpriv_open(filename, access, 0666);
    if (fd == -1)
        return AVERROR(errno);
    c->fd = fd;

    h->is_streamed = !fstat(fd, &st) && S_ISFIFO(st.st_mode);

    return 0;
}

/* XXX: use llseek */
static int64_t file_seek(URLContext *h, int64_t pos, int whence)
{
    FileContext *c = h->priv_data;
    int64_t ret;

    if (whence == AVSEEK_SIZE) {
        struct stat st;
        ret = fstat(c->fd, &st);
        return ret < 0 ? AVERROR(errno) : (S_ISFIFO(st.st_mode) ? 0 : st.st_size);
    }

    ret = lseek(c->fd, pos, whence);

    return ret < 0 ? AVERROR(errno) : ret;
}

static int file_close(URLContext *h)
{
    FileContext *c = h->priv_data;
    return close(c->fd);
}

static int file_open_dir(URLContext *h)
{
#if HAVE_LSTAT
    FileContext *c = h->priv_data;

    c->dir = opendir(h->filename);
    if (!c->dir)
        return AVERROR(errno);

    return 0;
#else
    return AVERROR(ENOSYS);
#endif /* HAVE_LSTAT */
}

static int file_read_dir(URLContext *h, AVIODirEntry **next)
{
#if HAVE_LSTAT
    FileContext *c = h->priv_data;
    struct dirent *dir;
    char *fullpath = NULL;

    *next = ff_alloc_dir_entry();
    if (!*next)
        return AVERROR(ENOMEM);
    do {
        errno = 0;
        dir = readdir(c->dir);
        if (!dir) {
            av_freep(next);
            return AVERROR(errno);
        }
    } while (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, ".."));

    fullpath = av_append_path_component(h->filename, dir->d_name);
    if (fullpath) {
        struct stat st;
        if (!lstat(fullpath, &st)) {
            if (S_ISDIR(st.st_mode))
                (*next)->type = AVIO_ENTRY_DIRECTORY;
            else if (S_ISFIFO(st.st_mode))
                (*next)->type = AVIO_ENTRY_NAMED_PIPE;
            else if (S_ISCHR(st.st_mode))
                (*next)->type = AVIO_ENTRY_CHARACTER_DEVICE;
            else if (S_ISBLK(st.st_mode))
                (*next)->type = AVIO_ENTRY_BLOCK_DEVICE;
            else if (S_ISLNK(st.st_mode))
                (*next)->type = AVIO_ENTRY_SYMBOLIC_LINK;
            else if (S_ISSOCK(st.st_mode))
                (*next)->type = AVIO_ENTRY_SOCKET;
            else if (S_ISREG(st.st_mode))
                (*next)->type = AVIO_ENTRY_FILE;
            else
                (*next)->type = AVIO_ENTRY_UNKNOWN;

            (*next)->group_id = st.st_gid;
            (*next)->user_id = st.st_uid;
            (*next)->size = st.st_size;
            (*next)->filemode = st.st_mode & 0777;
            (*next)->modification_timestamp = INT64_C(1000000) * st.st_mtime;
            (*next)->access_timestamp =  INT64_C(1000000) * st.st_atime;
            (*next)->status_change_timestamp = INT64_C(1000000) * st.st_ctime;
        }
        av_free(fullpath);
    }

    (*next)->name = av_strdup(dir->d_name);
    return 0;
#else
    return AVERROR(ENOSYS);
#endif /* HAVE_LSTAT */
}

static int file_close_dir(URLContext *h)
{
#if HAVE_LSTAT
    FileContext *c = h->priv_data;
    closedir(c->dir);
    return 0;
#else
    return AVERROR(ENOSYS);
#endif /* HAVE_LSTAT */
}

URLProtocol ff_file_protocol = {
    .name                = "file",
    .url_open            = file_open,
    .url_read            = file_read,
    .url_write           = file_write,
    .url_seek            = file_seek,
    .url_close           = file_close,
    .url_get_file_handle = file_get_handle,
    .url_check           = file_check,
    .url_delete          = file_delete,
    .url_move            = file_move,
    .priv_data_size      = sizeof(FileContext),
    .priv_data_class     = &file_class,
    .url_open_dir        = file_open_dir,
    .url_read_dir        = file_read_dir,
    .url_close_dir       = file_close_dir,
    .default_whitelist   = "file,crypto"
};

#endif /* CONFIG_FILE_PROTOCOL */

#if CONFIG_PIPE_PROTOCOL

static int pipe_open(URLContext *h, const char *filename, int flags)
{
    FileContext *c = h->priv_data;
    int fd;
    char *final;
    av_strstart(filename, "pipe:", &filename);

    fd = strtol(filename, &final, 10);
    if((filename == final) || *final ) {/* No digits found, or something like 10ab */
        if (flags & AVIO_FLAG_WRITE) {
            fd = 1;
        } else {
            fd = 0;
        }
    }
#if HAVE_SETMODE
    setmode(fd, O_BINARY);
#endif
    c->fd = fd;
    h->is_streamed = 1;
    return 0;
}

URLProtocol ff_pipe_protocol = {
    .name                = "pipe",
    .url_open            = pipe_open,
    .url_read            = file_read,
    .url_write           = file_write,
    .url_get_file_handle = file_get_handle,
    .url_check           = file_check,
    .priv_data_size      = sizeof(FileContext),
    .priv_data_class     = &pipe_class,
    .default_whitelist   = "crypto"
};

#endif /* CONFIG_PIPE_PROTOCOL */
