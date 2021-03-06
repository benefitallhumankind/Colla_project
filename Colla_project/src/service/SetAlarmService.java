package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dao.SetAlarmDao;
import model.SetAlarm;

@Service
public class SetAlarmService {

	@Autowired
	SetAlarmDao setAlarmDao;
	
	public boolean addSetAlarm(SetAlarm setAlarm) {
		if(setAlarmDao.insertSetAlarm(setAlarm.getNum())>0) {
			return true;
		}
		return false;
	}
	
	public boolean modifySetAlarm(String type, int result,int mNum) {
		if(setAlarmDao.updateSetAlarm(type,result,mNum)>0) {
			return true;
		}
		return false;
	}
	
	public SetAlarm getSetAlarm(int mNum){
		return setAlarmDao.selectSetAlarm(mNum);
	}
	
	public boolean removeSetAlarm(int mNum) {
		if(setAlarmDao.deleteSetAlarm(mNum)>0) {
			return true;
		}
		return false;
	}
}
