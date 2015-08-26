#include "Semaphore.h"

Semaphore::Semaphore(value_t start_val)
{
	sem_init(&m_sem, 0, start_val);
}

Semaphore::~Semaphore()
{
	sem_destroy(&m_sem);
}

int Semaphore::Post()
{
	return sem_post(&m_sem);
}


int Semaphore::Wait()
{
	return sem_wait(&m_sem);
}

int Semaphore::TryWait()
{
	return sem_trywait(&m_sem);
}


int Semaphore::GetValue(int& i)
{
	return sem_getvalue(&m_sem, &i);
}

