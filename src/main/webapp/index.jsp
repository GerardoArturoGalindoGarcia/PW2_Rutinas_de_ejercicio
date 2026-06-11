<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login - Rutinas de Ejercicio</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; padding: 50px; text-align: center; }
        .login-box { background: white; padding: 30px; display: inline-block; border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
        input { display: block; margin: 10px auto; padding: 10px; width: 200px; }
        button { padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Control de Rutinas</h2>

    <%-- Procesar el formulario aquí mismo --%>
    <%
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        if (usuario != null && clave != null) {
            // Un login quemado simple para la clase
            if (usuario.equals("admin") && clave.equals("1234")) {
                // Guardamos el usuario en la sesión para proteger las otras páginas
                session.setAttribute("usuarioLogueado", usuario);
                response.sendRedirect("dashboard.jsp");
                return;
            } else {
    %>
    <p style="color: red;">¡Usuario o contraseña incorrectos!</p>
    <%
            }
        }
    %>

    <form action="index.jsp" method="POST">
        <input type="text" name="usuario" placeholder="Usuario (admin)" required>
        <input type="password" name="clave" placeholder="Contraseña (1234)" required>
        <button type="submit">Ingresar</button>
    </form>
</div>

</body>
</html>