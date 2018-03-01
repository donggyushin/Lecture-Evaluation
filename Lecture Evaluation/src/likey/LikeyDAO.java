package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class LikeyDAO {

	public int like(String userID, String evaluationID, String userIP) {
		String SQL = "insert into likey values(?,?,?)";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setInt(2, Integer.parseInt(evaluationID));
			pstmt.setString(3, userIP);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {if(pstmt!= null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
			try {if(rs!= null) rs.close();}catch(Exception e) {e.printStackTrace();}
			try {if(conn!= null) conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return -1;	//중복으로 인한 추천 실패
	}
}
