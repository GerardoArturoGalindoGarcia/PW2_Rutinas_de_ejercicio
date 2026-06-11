<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%
    // CONTROL DE SEGURIDAD: Si no se ha logueado, lo mandamos al login
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Inicializar la lista de favoritos en la sesión si no existe
    ArrayList<String> favoritos = (ArrayList<String>) session.getAttribute("favoritos");
    if (favoritos == null) {
        favoritos = new ArrayList<>();
        session.setAttribute("favoritos", favoritos);
    }

    // Capturar si el usuario quiere agregar un favorito
    String nuevaFav = request.getParameter("agregarFavorito");
    if (nuevaFav != null && !favoritos.contains(nuevaFav)) {
        favoritos.add(nuevaFav);
    }

    // Capturar el filtro de tipo de ejercicio (Cardio o Fuerza)
    String filtro = request.getParameter("tipo");
    if (filtro == null) filtro = "TODOS";
%>
<html>
<head>
    <title>Dashboard - Mis Rutinas</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; display: flex; }
        .sidebar { width: 250px; background: #343a40; color: white; padding: 20px; height: 100vh; }
        .content { flex-content: 1; padding: 30px; background: #f8f9fa; width: 100%; }
        .card { background: white; padding: 15px; margin: 10px 0; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .btn-fav { background: #ffc107; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px; }
        .sidebar a { color: #ffc107; text-decoration: none; display: block; margin-top: 10px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h3>Filtros</h3>
    <p><a href="dashboard.jsp?tipo=TODOS">📋 Ver Todas</a></p>
    <p><a href="dashboard.jsp?tipo=CARDIO">🏃‍♂️ Cardio</a></p>
    <p><a href="dashboard.jsp?tipo=FUERZA">🏋️‍♂️ Fuerza</a></p>

    <hr>
    <h3>⭐ Mis Favoritos</h3>
    <ul>
        <% if (favoritos.isEmpty()) { %>
        <li>Ninguna guardada</li>
        <% } else {
            for(String fav : favoritos) { %>
        <li><%= fav %></li>
        <%   }
        } %>
    </ul>
    <br>
    <a href="logout.jsp" style="color: #dc3545;">❌ Cerrar Sesión</a>
</div>

<div class="content">
    <h2>Listado de Rutinas (<%= filtro %>)</h2>

    <%-- RUTINA 1 --%>
    <% if (filtro.equals("TODOS") || filtro.equals("CARDIO")) { %>
    <div class="card">
        <h3>🏃‍♂️ Saltar la Cuerda Intenso</h3>
        <p><strong>Tipo:</strong> Cardio | <strong>Duración:</strong> 15 minutos</p>
        <p>Mejora la resistencia cardiovascular y la coordinación rápidamente.</p>
        <form action="dashboard.jsp" method="POST">
            <input type="hidden" name="agregarFavorito" value="Saltar la Cuerda Intenso">
            <input type="hidden" name="tipo" value="<%= filtro %>">
            <button type="submit" class="btn-fav">⭐ Agregar a Favoritos</button>
        </form>
    </div>
    <% } %>

    <%-- RUTINA 2 --%>
    <% if (filtro.equals("TODOS") || filtro.equals("FUERZA")) { %>
    <div class="card">
        <h3>🏋️‍♂️ Hipertrofia de Pecho y Tríceps</h3>
        <p><strong>Tipo:</strong> Fuerza | <strong>Duración:</strong> 45 minutos</p>
        <p>Flexiones de pecho, press de banca y fondos en paralelas.</p>
        <form action="dashboard.jsp" method="POST">
            <input type="hidden" name="agregarFavorito" value="Hipertrofia de Pecho y Tríceps">
            <input type="hidden" name="tipo" value="<%= filtro %>">
            <button type="submit" class="btn-fav">⭐ Agregar a Favoritos</button>
        </form>
    </div>
    <% } %>

    <%-- RUTINA 3 --%>
    <% if (filtro.equals("TODOS") || filtro.equals("CARDIO")) { %>
    <div class="card">
        <h3>🚴‍♂️ HIIT en Bicicleta Estática</h3>
        <p><strong>Tipo:</strong> Cardio | <strong>Duración:</strong> 20 minutos</p>
        <p>Intervalos de 30 segundos a máxima velocidad por 1 minuto de descanso.</p>
        <form action="dashboard.jsp" method="POST">
            <input type="hidden" name="agregarFavorito" value="HIIT en Bicicleta Estática">
            <input type="hidden" name="tipo" value="<%= filtro %>">
            <button type="submit" class="btn-fav">⭐ Agregar a Favoritos</button>
        </form>
    </div>
    <% } %>

    <%-- RUTINA 4 --%>
    <% if (filtro.equals("TODOS") || filtro.equals("FUERZA")) { %>
    <div class="card">
        <h3>🦵 Sentadillas y Fuerza de Piernas</h3>
        <p><strong>Tipo:</strong> Fuerza | <strong>Duración:</strong> 30 minutos</p>
        <p>Sentadillas libres, desplantes y elevación de talones.</p>
        <form action="dashboard.jsp" method="POST">
            <input type="hidden" name="agregarFavorito" value="Sentadillas y Fuerza de Piernas">
            <input type="hidden" name="tipo" value="<%= filtro %>">
            <button type="submit" class="btn-fav">⭐ Agregar a Favoritos</button>
        </form>
    </div>
    <% } %>
</div>

</body>
</html>