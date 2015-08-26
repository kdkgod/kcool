/*
 * author : dekun.kong
 * email : kongdekun999@163.com
 *
*/
#ifndef _KCOOL_LCH_MUTEX_65HF6HD6_H_
#define _KCOOL_LCH_MUTEX_65HF6HD6_H_

#include <pthread.h>


/** CMutex container class, used by Lock.
	\ingroup threading */
class CMutex
{
public:
	CMutex();
	~CMutex();

	/*
	*	mutex lock
	*/
	virtual void lock() const;

	/*
	*	mutex unlock
	*/
	virtual void unLock() const;

private:
	mutable pthread_mutex_t m_mutex;
};

#endif

