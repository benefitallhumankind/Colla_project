package dao;

import java.util.List;

import model.Reply;

public interface ReplyDao {
	public List<Reply> selectReplyByBnum(int bNum);
	public int insertReply(Reply r);
	public int updateReply(Reply r);
	public int deleteReply(int rNum);
}
