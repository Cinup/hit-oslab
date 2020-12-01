//实现iam和whoami系统调用
#include <errno.h>
#include <asm/segment.h>
char msg[24] = {'\0'};
unsigned short int msg_length = 0;
const unsigned short int max_length = 23;
//将name的内容拷贝到内核中保存下来,要求name的长度不超过23个字符
//返回拷贝的字符数,如果name超过23个字符,返回-1,并置errno为EINVAL.
int sys_iam(const char *name)
{
    //统计name的长度
    int length = 0;
    while (get_fs_byte(name + length) != '\0')
    {
        length++;
        //尽早发现错误
        if (length > max_length)
        {
            break;
        }
    }
    //如果超过上限
    if (length > max_length)
    {
        return -EINVAL;
    }
    msg_length = length;
    int i = 0;
    while (i < msg_length + 1)
    {
        msg[i] = get_fs_byte(name + i);
        i++;
    }
    return msg_length;
}
//将iam保存的字符拷贝到name指向的用户地址空间中,size指定空间大小
//返回拷贝的字符数,如果size小于需要的空间，则返回-1,并置errno为EINVAL
int sys_whoami(char *name, unsigned int size)
{
    if (size < msg_length)
    {
        return -EINVAL;
    }
    int i = 0;
    //将结尾的'\0'也拷贝过去
    while (i < msg_length + 1)
    {
        put_fs_byte(msg[i], name + i);
        i++;
    }
    return msg_length;
}