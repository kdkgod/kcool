#include "Mutex.h"

CMutex::CMutex()
{
	pthread_mutex_init(&m_mutex, NULL);
}

CMutex::~CMutex()
{
	pthread_mutex_destroy(&m_mutex);
}


void CMutex::lock() const
{
	pthread_mutex_lock(&m_mutex);
}


void CMutex::unLock() const
{
	pthread_mutex_unlock(&m_mutex);
}

