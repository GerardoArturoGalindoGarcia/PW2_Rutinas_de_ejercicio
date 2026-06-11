<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login - Rutinas de Ejercicio</title>
    <style>
        /* Fondo de toda la página con imagen de gimnasio (cubre todo el viewport) */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            background-image: url('https://wallpapercave.com/wp/wp12424948.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 50px;
            text-align: center;
        }

        /* Caja de login centrada, semitransparente para legibilidad sobre la imagen */
        .login-box {
            background: rgba(255,255,255,0.92);
            padding: 30px;
            display: inline-block;
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.18);
            max-width: 380px;
            width: 100%;
        }

        /* Formulario dentro de la caja */
        .login-form { text-align: center; }
        input { display: block; margin: 10px auto; padding: 10px; width: 100%; box-sizing: border-box; }
        button { padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }

        /* Etiqueta accesible oculta visualmente */
        .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }

        @media (max-width: 480px) {
            body { padding: 20px; }
            .login-box { padding: 20px; }
        }
    </style>
</head>
<body>

<div class="login-box">
    <div class="login-form">
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
            <label class="sr-only" for="usuario">Usuario</label>
            <input id="usuario" type="text" name="usuario" placeholder="Usuario" required>

            <label class="sr-only" for="clave">Contraseña</label>
            <input id="clave" type="password" name="clave" placeholder="Contraseña" required>

            <button type="submit">Ingresar</button>
        </form>
    </div>
</div>

</body>
</html>