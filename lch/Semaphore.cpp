#include "Semaphore.h"

CSemaphore::CSemaphore(value_t start_val)
{
	sem_init(&m_sem, 0, start_val);
}

CSemaphore::~CSemaphore()
{
	sem_destroy(&m_sem);
}

int CSemaphore::Post()
{
	return sem_post(&m_sem);
}

int CSemaphore::Wait()
{
	return sem_wait(&m_sem);
}

int CSemaphore::TryWait()
{
	return sem_trywait(&m_sem);
}

int CSemaphore::GetValue(int& i)
{
	return sem_getvalue(&m_sem, &i);
}

