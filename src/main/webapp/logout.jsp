<%@ page contentType="text/html;charset=UTF-8" %>
<%
  // Destruye la sesión del usuario
  session.invalidate();
  response.sendRedirect("index.jsp");
%>