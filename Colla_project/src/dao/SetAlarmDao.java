package dao;

import java.util.Map;

import model.SetAlarm;

public interface SetAlarmDao {
	public int insertSetAlarm(SetAlarm setAlarm);
	public int updateSetAlarm(String type, int result,int mNum);
	public int deleteSetAlarm(int num);
	public SetAlarm selectSetAlarm(int mNum);
}