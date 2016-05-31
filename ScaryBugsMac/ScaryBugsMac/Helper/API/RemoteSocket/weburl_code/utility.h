#ifndef __UTILITY_H__
#define __UTILITY_H__
//#include <rpcndr.h>
#ifdef __cplusplus
extern "C" {
#endif

#ifndef uint16
#define uint16  unsigned short int
#endif

#ifndef uint32
#define uint32 unsigned long int
#endif


//typedef unsigned long int uint32;
typedef unsigned char BYTE;

// �����ʹ�С�˻���
#define BigLittleSwap16(A) ((((uint16)(A) & 0xff00) >> 8) | (((uint16)(A) & 0x00ff) << 8))

// �����ʹ�С�˻���
#define BigLittleSwap32(A) ((((uint32)(A) & 0xff000000) >> 24) | \
		(((uint32)(A) & 0x00ff0000) >> 8) | \
		(((uint32)(A) & 0x0000ff00) << 8) | \
		(((uint32)(A) & 0x000000ff) << 24))

// ������˷���1��С�˷���0
int checkCPUendian();

// ģ��htonl�����������ֽ���ת�����ֽ���

unsigned long int t_htonl(unsigned long int h);

// ģ��ntohl�����������ֽ���ת�����ֽ���
unsigned long int t_ntohl(unsigned long int n);

// ģ��htons�����������ֽ���ת�����ֽ���

unsigned short int t_htons(unsigned short int h);

// ģ��ntohs�����������ֽ���ת�����ֽ���

unsigned short int t_ntohs(unsigned short int n);


//typedef unsigned long DWORD;


//DWORD ToLittleEndian(DWORD dwBigEndian);
char *bin2hex(char *bin,unsigned int bin_len);
char *hex2bin(char *hex,unsigned int hex_len);

/*
* @brief �������ֽڴ���ת������
* @param[in] nValue		�������������8
* @param[in] outlen		Ҫ����ֽڴ��ĳ���
* @param[out] outData	������ֽڴ�
* @return ���ز����ɹ����
* @retval 1 �����ɹ�
* @retval 0 ����ʧ��
*/
int	INTToByte(int nValue,int outlen,unsigned char** outData);


#ifdef __cplusplus
}
#endif
#endif