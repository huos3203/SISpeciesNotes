/**
 * @file HttpDes.h
 * @brief ���ڸ�http��������ĵط�û���õ���Ϊ���빫��ģ�����
 *		  ��Ӹ�ģ��
 * @author
 * @date
 * @version
*/
#ifndef __HTTPDES_H__
#define __HTTPDES_H__

#include "Des.h"
typedef unsigned char uchar;

class CHttpDes
{
public:
	CHttpDes();
	~CHttpDes();

public:
	/*
	 * @brief ��Ϊֻ�õ���pyc��վ��������Կ�ǹ̶��ģ���������������
	 * @param[in] szSrc		Ҫ���ܵ�����
	 * @param[in] nLen		Ҫ�������ݵĳ���
	 * @param[out] szOut	���ܺ������
	 * @return 
	 * @retval 1 �����ɹ�
	 * @retval 0 ����ʧ��
	 */
	int GetEntryText(char *szSrc, int nLen, char* szOut,int *retLen);
public:
    /*
     * @brief ��Ϊֻ�õ���pyc��վ��������Կ�ǹ̶��ģ���������������
     * @param[in] szSrc		Ҫ���ܵ�����
     * @param[in] nLen		Ҫ�������ݵĳ���
     * @param[out] szOut	���ܺ������
     * @return
     * @retval 1 �����ɹ�
     * @retval 0 ����ʧ��
     */
    int GetEntryTextnew(char *szSrc, int nLen, char* szOut,int *retLen);
public:
	/*
	 * @brief ��Ϊֻ�õ���pyc��վ��������Կ�ǹ̶��ģ���������������
	 * @param[in] szSrc		Ҫ���ܵ�����
	 * @param[in] nLen		Ҫ�������ݵĳ���
	 * @param[out] szOut	���ܺ������
	 * @return 
	 * @retval 1 �����ɹ�
	 * @retval 0 ����ʧ��
	 */
	int GetDecryptText(char *szSrc, int nLen, char* szOut);
public:
	/*
	 * @brief ���ܣ���mode = ecb , padding = pkcs7 ������
	 *				���to == NULL, �򷵻ؼ��ܺ����ݵĳ���
	 * @param[in] from		Ҫ���ܵ�����
	 * @param[in] nLength	Ҫ�������ݵĳ���
	 * @param[out] to		���ܺ������
	 * @param[in]  key[]	�����õ���key
	 */
	int des_ecb_pkcs7_encrypt(uchar* from, int nLength,  uchar * to, uchar key[]);

	/*
	 * @brief ���ܣ���mode = ecb , padding = pkcs7 ������
	 *
	 * @param[in] from		Ҫ���ܵ�����
	 * @param[in] nLength	Ҫ�������ݵĳ���
	 * @param[out] to		���ܺ������
	 * @param[in]  key[]	�����õ���key
	 */
	int des_ecb_pkcs7_decrypt(uchar* from, int nLength,  uchar * to, uchar key[]);

	/*
	 * @brief	��mode = cbc , padding = pkcs7 ����������
	 *			���to == NULL, �򷵻ؼ��ܺ����ݵĳ���
	 * @param[in]  from		Ҫ���ܵ�����
	 * @param[in]  nLength	Ҫ�������ݵĳ���
	 * @param[out] to		���ܺ������
	 * @param[in]  key[]	�����õ���key
	 * @param[in]  iv[]		�������ݵ�key����
	 */
	int des_cbc_pkcs7_encrypt(uchar* from, int nLength,  uchar * to, uchar key[],uchar iv[]);

	/*
	 * @brief	��mode = cbc , padding = pkcs7 ����������
	 *			���to == NULL, �򷵻ؼ��ܺ����ݵĳ���
	 * @param[in]  from		Ҫ���ܵ�����
	 * @param[in]  nLength	Ҫ�������ݵĳ���
	 * @param[out] to		���ܺ������
	 * @param[in]  key[]	�����õ���key
	 * @param[in]  iv[]		�����õ���key����
	 */
	int des_cbc_pkcs7_decrypt(uchar* from, int nLength,  uchar * to, uchar key[], uchar iv[]);


	/*
	 * @brief	���ֽ�����ת�����ִ�
	 * @param[in]  bytes	Ҫת��������
	 * @param[in]  nLength	Ҫת�������ݳ���
	 * @param[out] pszout	ת���������
	 */
	int Byte2String(uchar* bytes, int nLength, char* pszout);
	/*
	 * @brief ���Գ���
	 */
	void cbcDesTest1();
};

#endif