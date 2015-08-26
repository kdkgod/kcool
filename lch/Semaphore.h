/*
 * author : dekun.kong
 * email : kongdekun999@163.com
 *
*/
#ifndef _KCOOL_LCH_SEMAPHORE_H_6GFHJ6_
#define _KCOOL_LCH_SEMAPHORE_H_6GFHJ6_

#include <pthread.h>
#include <semaphore.h>


typedef unsigned int value_t;

/*
 *	only support same process
*/
class CSemaphore
{
public:
	CSemaphore(value_t start_val = 0);
	~CSemaphore();

	/** \return 0 if successful */
	int Post();
	/** Wait for Post
	    \return 0 if successful */
	int Wait();

	/** \return 0 if successful */
	int TryWait();

	/** \return 0 if successful */
	int GetValue(int&);

private:
	CSemaphore(const CSemaphore& ) {} // copy constructor
	CSemaphore& operator=(const CSemaphore& ) { return *this; } // assignment operator
	sem_t m_sem;
};

#endif

