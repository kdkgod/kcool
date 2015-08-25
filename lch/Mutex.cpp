#include "Mutex.h"

Mutex::Mutex()
{
	pthread_mutex_init(&m_mutex, NULL);
}


Mutex::~Mutex()
{
	pthread_mutex_destroy(&m_mutex);
}


void Mutex::lock() const
{
	pthread_mutex_lock(&m_mutex);
}


void Mutex::unLock() const
{
	pthread_mutex_unlock(&m_mutex);
}

