/*
 * author : dekun.kong
 * email : kongdekun999@163.com
 *
*/
#ifndef _KCOOL_LCH_TIMER_H_65J327DY_
#define _KCOOL_LCH_TIMER_H_65J327DY_

class CTimerTask
{
public:
	virtual ~CTimerTask();
	virtual void Run() = 0;
};

enum TimerType {
	TIMER_ONCE = 1,
	TIMER_PERIODIC
};

class CTimer
{
public:
	CTimer();
	virtual ~CTimer();
public:
	bool Init(TimerType timertype);
	void Uninit();
	bool Schedule(CTimerTask *pTask, unsigned int s, unsigned int ns);
private:
	TimerType m_eTimerType;
	bool m_bInit;
};

#endif

