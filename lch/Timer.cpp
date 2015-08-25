#include "Timer.h"

CTimerTask::~CTimerTask()
{
}

CTimer::CTimer()
	: m_bInit(false)
{
}

CTimer::~CTimer()
{
	if (m_bInit) {
		Uninit();
		m_bInit = false;
	}
}

bool CTimer::Init(TimerType timertype)
{
	if (m_bInit) return false;

	m_eTimerType = timertype;
	m_bInit = true;

	return true;
}

void CTimer::Uninit()
{
	m_bInit = false;
}

bool CTimer::Schedule(CTimerTask *pTask, unsigned int s, unsigned int ns)
{
	if (!m_bInit) return false;

	return true;
}

