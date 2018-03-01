package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {
	//강의평가 등록 함수
	public int write(EvaluationDTO evaluation) {
		String SQL ="INSERT INTO evaluation values(null, ?,?,?,?,?,?,?,?,?,?,?,?,0)";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, evaluation.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(2, evaluation.getLectureName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(3, evaluation.getProfessorName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setInt(4, evaluation.getLectureYear());
			pstmt.setString(5, evaluation.getSemesterDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(6, evaluation.getLectureDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(7, evaluation.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(8, evaluation.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(9, evaluation.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(10, evaluation.getCreditScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(11, evaluation.getComfortableScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			pstmt.setString(12, evaluation.getLectureScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll(" ", "&nbsp;").replaceAll("\n", "<br>"));
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {

			try {if(pstmt != null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();}catch(Exception e) {e.printStackTrace();}
			try {if(conn != null) conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return -1;//데이터베이스 오류
	}
	
	public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber){
		String SQL = "";
		if(lectureDivide.equals("전체")) {
			lectureDivide = "";
		}
		ArrayList<EvaluationDTO> evaluationList = null;
		PreparedStatement pstmt =null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			if(searchType.equals("최신순")) {
				SQL = "select * from evaluation where lectureDivide like ? and concat(lectureName, professorName, evaluationTitle"
						+ ", evaluationContent) like ? order by evaluationID DESC limit " + pageNumber * 5 + "," + pageNumber*5 + 6;
			}else if(searchType.equals("추천순")) {
				SQL = "select * from evaluation where lectureDivide like ? and concat(lectureName, professorName, evaluationTitle"
						+ ", evaluationContent) like ? order by likeCount DESC limit " + pageNumber * 5 + "," + pageNumber*5 + 6;
				
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%"+lectureDivide+"%");
			pstmt.setString(2, "%"+search+"%");
			evaluationList = new ArrayList<EvaluationDTO>();
			rs = pstmt.executeQuery();
			while(rs.next()) {
				EvaluationDTO evaluation = new EvaluationDTO(
						rs.getInt(1),
						rs.getString(2),
						rs.getString(3),
						rs.getString(4),
						rs.getInt(5),
						rs.getString(6),
						rs.getString(7),
						rs.getString(8),
						rs.getString(9),
						rs.getString(10),
						rs.getString(11),
						rs.getString(12),
						rs.getString(13),
						rs.getInt(14)
						);
				evaluationList.add(evaluation);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {

			try {if(pstmt != null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();}catch(Exception e) {e.printStackTrace();}
			try {if(conn != null) conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return evaluationList;
	}
	
	//좋아요 하나 늘려주는 함수
	public int like(String evaluationID) {
		String SQL = "update evaluation set likeCount = likeCount + 1 where evaluationID = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {

			try {if(pstmt != null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();}catch(Exception e) {e.printStackTrace();}
			try {if(conn != null) conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return -1 ;	//데이터베이스 오류
	}
	
	
	//게시글 지우는 함수
	public int delete(String evaluationID) {
		String SQL = "delete from evaluation where evaluationID = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = DatabaseUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {if(pstmt != null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();}catch(Exception e) {e.printStackTrace();}
			try {if(conn != null) conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return -1 ;	//데이터베이스 오류
	}
	
	
	public String getUserID(String evaluationID) {
		String SQL = "select userID from evaluation where evaluationID = ?";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				System.out.println("여긴 못들어오겠지?");
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {if(pstmt != null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();}catch(Exception e) {e.printStackTrace();}
			try {if(conn != null) conn.close();}catch(Exception e) {e.printStackTrace();}
		}
		return null ;	//데이터베이스 오류
	}
	
}
