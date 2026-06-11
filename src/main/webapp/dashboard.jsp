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

    // Capturar si el usuario quiere agregar o eliminar un favorito
    String nuevaFav = request.getParameter("agregarFavorito");
    String eliminarFav = request.getParameter("eliminarFavorito");
    // Procesar eliminación primero si existe la petición
    if (eliminarFav != null && favoritos.contains(eliminarFav)) {
        favoritos.remove(eliminarFav);
    } else if (nuevaFav != null && !favoritos.contains(nuevaFav)) {
        favoritos.add(nuevaFav);
    }

    // Capturar el filtro de tipo de ejercicio (Cardio o Fuerza)
    String filtro = request.getParameter("tipo");
    if (filtro == null) filtro = "TODOS";
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Mis Rutinas</title>
    <!-- Google Font: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{
            --bg-primary: #0a0a0a;
            --sidebar-bg: #111111;
            --card-bg: #1a1a1a;
            --accent: #f5a623;
            --accent-hover: #e0941f;
            --text-primary: #ffffff;
            --text-secondary: #a0a0a0;
            --cardio: #e74c3c;
            --fuerza: #3498db;
            --border: #2a2a2a;
            --font: 'Inter', sans-serif;
        }

        *,*::before,*::after{box-sizing:border-box}
        html,body{height:100%;margin:0;background:var(--bg-primary);font-family:var(--font);color:var(--text-primary);-webkit-font-smoothing:antialiased}

        /* Layout */
        .app{display:flex;min-height:100vh}
        .sidebar{width:260px;background:var(--sidebar-bg);padding:24px 20px;display:flex;flex-direction:column;height:100vh;border-right:1px solid var(--border)}
        .logo{display:flex;align-items:center;gap:12px;margin-bottom:14px}
        .logo .emoji{font-size:28px}
        .logo .brand{font-size:18px;font-weight:700;color:var(--accent);text-transform:uppercase;letter-spacing:2px}
        .separator{height:1px;background:var(--border);margin:12px 0}
        .label{font-size:10px;color:var(--text-secondary);text-transform:uppercase;letter-spacing:2px;margin-bottom:8px}
        .filters{display:flex;flex-direction:column;gap:8px}
        .filter-link{display:flex;align-items:center;gap:10px;padding:10px 14px;border-radius:8px;color:var(--text-primary);font-size:14px;text-decoration:none}
        .filter-link:hover,.filter-link:focus{background:#252525}
        .filter-link.active{background:var(--accent);color:#000;font-weight:600}

        .favorites{margin-top:18px}
        .fav-list{list-style:none;padding:0;margin:8px 0 0;display:flex;flex-direction:column;gap:6px}
        .fav-item{padding:8px 12px;font-size:13px;color:#d0d0d0;background:#252525;border-radius:6px;margin:0}
        .fav-empty{font-style:italic;color:var(--text-secondary)}

        .logout{margin-top:auto}
        .logout a{display:flex;align-items:center;gap:8px;color:#e74c3c;font-size:14px;padding:10px 14px;border-radius:8px;text-decoration:none}
        .logout a:hover{background:#1f0a0a}

        /* Main */
        .main{flex:1;padding:32px;min-height:100vh;color:var(--text-primary)}
        .header{display:flex;align-items:center;justify-content:space-between}
        .title-wrap{display:flex;flex-direction:column}
        .title{font-size:28px;font-weight:800;color:var(--text-primary);letter-spacing:0.4px}
        .title-underline{width:40px;height:3px;background:var(--accent);margin-top:8px;border-radius:2px}

        .user{display:flex;align-items:center;gap:12px}
        .avatar{width:40px;height:40px;border-radius:50%;background:#2a2a2a;display:flex;align-items:center;justify-content:center;color:var(--text-secondary);font-weight:700}
        .username{font-size:14px;color:var(--text-primary)}

        /* Stat bar */
        .stats{display:flex;gap:16px;margin:24px 0 20px}
        .stat{background:var(--card-bg);border:1px solid var(--border);border-radius:10px;padding:14px 20px;display:flex;flex-direction:column;min-width:120px}
        .stat .value{font-size:24px;font-weight:800;color:var(--accent)}
        .stat .label{font-size:12px;color:var(--text-secondary);text-transform:uppercase;letter-spacing:1px;margin-top:6px}

        /* Filter tabs */
        .tabs{display:flex;gap:12px;margin-top:8px}
        .tab{padding:8px 22px;border-radius:20px;font-size:14px;text-decoration:none;display:inline-block;transition:background 0.2s;border:1px solid var(--border)}
        .tab.inactive{background:var(--card-bg);color:var(--text-secondary)}
        .tab.active{background:var(--accent);color:#000;font-weight:700}
        .tab:focus{outline:2px solid rgba(245,166,35,0.18);outline-offset:2px}

        /* Cards grid */
        .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:24px;margin-top:28px}

        .card{background:var(--card-bg);border-radius:12px;border:1px solid var(--border);overflow:hidden;display:flex;flex-direction:column;transition:all 0.25s ease}
        .card:hover{transform:translateY(-4px);box-shadow:0 8px 24px rgba(245,166,35,0.12);border-color:var(--accent)}
        .card-banner{height:6px;width:100%}
        .card-banner.cardio{background:var(--cardio)}
        .card-banner.fuerza{background:var(--fuerza)}
        .card-body{padding:20px 22px 22px;flex:1;display:flex;flex-direction:column}
        .badge{display:inline-block;text-transform:uppercase;font-size:11px;font-weight:700;letter-spacing:1px;border-radius:20px;padding:3px 10px}
        .badge.cardio{background:rgba(231,76,60,0.15);color:var(--cardio);border:1px solid rgba(231,76,60,0.3)}
        .badge.fuerza{background:rgba(52,152,219,0.15);color:var(--fuerza);border:1px solid rgba(52,152,219,0.3)}
        .card-title{font-size:17px;font-weight:700;color:var(--text-primary);margin:10px 0 6px}
        .meta{display:flex;gap:16px;font-size:13px;color:var(--text-secondary);align-items:center}
        .desc{font-size:14px;color:#c0c0c0;line-height:1.6;margin:10px 0 18px}

        .btn{width:100%;background:var(--accent);color:#000;font-weight:700;font-size:13px;border:none;border-radius:8px;padding:10px;cursor:pointer;transition:background 0.2s}
        .btn:hover{background:var(--accent-hover)}
        .btn.disabled{background:var(--border);color:var(--text-secondary);cursor:default}
        .btn.remove{width:100%;background:#2a2a2a;color:var(--text-secondary);font-weight:700;font-size:13px;border:1px solid rgba(255,255,255,0.03);border-radius:8px;padding:10px;cursor:pointer;transition:background 0.15s}
        .btn.remove:hover{background:#272727}

        /* small utilities */
        .muted{color:var(--text-secondary)}
        a{color:inherit}

        @media (max-width:920px){
            .grid{grid-template-columns:repeat(auto-fill,minmax(280px,1fr))}
        }
        @media (max-width:720px){
            .sidebar{position:relative;width:220px}
            .grid{grid-template-columns:1fr}
            .header{flex-direction:column;align-items:flex-start;gap:12px}
        }
    </style>
</head>
<body>
<div class="app">
    <aside class="sidebar">
        <div class="top">
            <div class="logo">
                <div class="emoji">🏋️</div>
                <div class="brand">GYMTRACK</div>
            </div>
            <div class="separator"></div>

            <div class="label">CATEGORÍAS</div>
            <div class="filters">
                <a href="dashboard.jsp?tipo=TODOS" class="filter-link <%= filtro.equals("TODOS") ? "active" : "" %>">📋 Todos</a>
                <a href="dashboard.jsp?tipo=CARDIO" class="filter-link <%= filtro.equals("CARDIO") ? "active" : "" %>">🏃‍♂️ Cardio</a>
                <a href="dashboard.jsp?tipo=FUERZA" class="filter-link <%= filtro.equals("FUERZA") ? "active" : "" %>">🏋️‍♂️ Fuerza</a>
            </div>

            <div class="favorites">
                <div class="label">Favoritos</div>
                <ul class="fav-list">
                    <% if (favoritos.isEmpty()) { %>
                        <li class="fav-empty">Sin favoritos aún</li>
                    <% } else {
                        for(String fav : favoritos) { %>
                            <li class="fav-item"><%= fav %></li>
                    <%   }
                    } %>
                </ul>
            </div>
        </div>

        <div class="logout">
            <a href="logout.jsp">✖ Cerrar sesión</a>
        </div>
    </aside>

    <main class="main">
        <div class="header">
            <div class="title-wrap">
                <div class="title">MIS RUTINAS</div>
                <div class="title-underline"></div>
            </div>
            <div class="user">
                <div class="avatar">👤</div>
                <div class="username"><%= session.getAttribute("usuarioLogueado") %></div>
            </div>
        </div>

        <div class="stats">
            <div class="stat">
                <div class="value">8</div>
                <div class="label">Total Rutinas</div>
            </div>
            <div class="stat">
                <div class="value"><%= favoritos.size() %></div>
                <div class="label">Favoritas</div>
            </div>
            <div class="stat">
                <div class="value">7 días</div>
                <div class="label">Semana activa</div>
            </div>
        </div>

        <div class="tabs">
            <a href="dashboard.jsp?tipo=TODOS" class="tab <%= filtro.equals("TODOS") ? "active" : "inactive" %>">Todos</a>
            <a href="dashboard.jsp?tipo=CARDIO" class="tab <%= filtro.equals("CARDIO") ? "active" : "inactive" %>">Cardio</a>
            <a href="dashboard.jsp?tipo=FUERZA" class="tab <%= filtro.equals("FUERZA") ? "active" : "inactive" %>">Fuerza</a>
        </div>

        <div class="grid">
            <%-- RUTINA 1 --%>
            <% if (filtro.equals("TODOS") || filtro.equals("CARDIO")) { %>
            <div class="card">
                <div class="card-banner cardio" style="background:var(--cardio)"></div>
                <div class="card-body">
                    <span class="badge cardio">Cardio</span>
                    <div class="card-title">🏃‍♂️ Saltar la Cuerda Intenso</div>
                    <div class="meta"><div>⏱ 15 min</div><div>🔥 Alta</div></div>
                    <div class="desc">Mejora la resistencia cardiovascular y la coordinación rápidamente.</div>
                    <% if (favoritos.contains("Saltar la Cuerda Intenso")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Saltar la Cuerda Intenso">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Saltar la Cuerda Intenso">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- RUTINA 2 --%>
            <% if (filtro.equals("TODOS") || filtro.equals("FUERZA")) { %>
            <div class="card">
                <div class="card-banner fuerza" style="background:var(--fuerza)"></div>
                <div class="card-body">
                    <span class="badge fuerza">Fuerza</span>
                    <div class="card-title">🏋️‍♂️ Hipertrofia de Pecho y Tríceps</div>
                    <div class="meta"><div>⏱ 45 min</div><div>🔥 Alta</div></div>
                    <div class="desc">Flexiones de pecho, press de banca y fondos en paralelas.</div>
                    <% if (favoritos.contains("Hipertrofia de Pecho y Tríceps")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Hipertrofia de Pecho y Tríceps">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Hipertrofia de Pecho y Tríceps">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- RUTINA 3 --%>
            <% if (filtro.equals("TODOS") || filtro.equals("CARDIO")) { %>
            <div class="card">
                <div class="card-banner cardio" style="background:var(--cardio)"></div>
                <div class="card-body">
                    <span class="badge cardio">Cardio</span>
                    <div class="card-title">🚴‍♂️ HIIT en Bicicleta Estática</div>
                    <div class="meta"><div>⏱ 20 min</div><div>🔥 Alta</div></div>
                    <div class="desc">Intervalos de 30 segundos a máxima velocidad por 1 minuto de descanso.</div>
                    <% if (favoritos.contains("HIIT en Bicicleta Estática")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="HIIT en Bicicleta Estática">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="HIIT en Bicicleta Estática">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- RUTINA 4 --%>
            <% if (filtro.equals("TODOS") || filtro.equals("FUERZA")) { %>
            <div class="card">
                <div class="card-banner fuerza" style="background:var(--fuerza)"></div>
                <div class="card-body">
                    <span class="badge fuerza">Fuerza</span>
                    <div class="card-title">🦵 Sentadillas y Fuerza de Piernas</div>
                    <div class="meta"><div>⏱ 30 min</div><div>🔥 Media-Alta</div></div>
                    <div class="desc">Sentadillas libres, desplantes y elevación de talones.</div>
                    <% if (favoritos.contains("Sentadillas y Fuerza de Piernas")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Sentadillas y Fuerza de Piernas">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Sentadillas y Fuerza de Piernas">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- CARDIO #3: Carrera por Intervalos HIIT --%>
            <% if (filtro.equals("TODOS") || filtro.equals("CARDIO")) { %>
            <div class="card">
                <div class="card-banner cardio" style="background:var(--cardio)"></div>
                <div class="card-body">
                    <span class="badge cardio">Cardio</span>
                    <div class="card-title">🔥 Carrera por Intervalos HIIT</div>
                    <div class="meta"><div>⏱ 25 min</div><div>🔥 Alta</div></div>
                    <div class="desc">Alterna sprints de 45 segundos con caminata de 1 minuto. Ideal para quemar grasa y mejorar el VO2 máximo en poco tiempo.</div>
                    <% if (favoritos.contains("Carrera por Intervalos HIIT")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Carrera por Intervalos HIIT">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Carrera por Intervalos HIIT">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- CARDIO #4: Natación de Resistencia --%>
            <% if (filtro.equals("TODOS") || filtro.equals("CARDIO")) { %>
            <div class="card">
                <div class="card-banner cardio" style="background:var(--cardio)"></div>
                <div class="card-body">
                    <span class="badge cardio">Cardio</span>
                    <div class="card-title">🏊 Natación de Resistencia</div>
                    <div class="meta"><div>⏱ 30 min</div><div>🔥 Media-Alta</div></div>
                    <div class="desc">Series de 4×100m estilo libre con 30 segundos de descanso. Trabaja todo el cuerpo con bajo impacto articular.</div>
                    <% if (favoritos.contains("Natación de Resistencia")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Natación de Resistencia">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Natación de Resistencia">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- FUERZA #3: Espalda y Bíceps con Peso Libre --%>
            <% if (filtro.equals("TODOS") || filtro.equals("FUERZA")) { %>
            <div class="card">
                <div class="card-banner fuerza" style="background:var(--fuerza)"></div>
                <div class="card-body">
                    <span class="badge fuerza">Fuerza</span>
                    <div class="card-title">💪 Espalda y Bíceps con Peso Libre</div>
                    <div class="meta"><div>⏱ 40 min</div><div>🔥 Media</div></div>
                    <div class="desc">Remo con barra, jalones al pecho y curl de bíceps en 3 series de 12 repeticiones. Construye anchura y grosor de espalda.</div>
                    <% if (favoritos.contains("Espalda y Bíceps con Peso Libre")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Espalda y Bíceps con Peso Libre">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Espalda y Bíceps con Peso Libre">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- FUERZA #4: Hombros y Core Funcional --%>
            <% if (filtro.equals("TODOS") || filtro.equals("FUERZA")) { %>
            <div class="card">
                <div class="card-banner fuerza" style="background:var(--fuerza)"></div>
                <div class="card-body">
                    <span class="badge fuerza">Fuerza</span>
                    <div class="card-title">🦾 Hombros y Core Funcional</div>
                    <div class="meta"><div>⏱ 35 min</div><div>🔥 Media</div></div>
                    <div class="desc">Press militar, elevaciones laterales, plancha con rotación y dead bug. Fortalece la cadena posterior y estabiliza el core.</div>
                    <% if (favoritos.contains("Hombros y Core Funcional")) { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="eliminarFavorito" value="Hombros y Core Funcional">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn remove" type="submit">✖ ELIMINAR FAVORITO</button>
                        </form>
                    <% } else { %>
                        <form action="dashboard.jsp" method="POST">
                            <input type="hidden" name="agregarFavorito" value="Hombros y Core Funcional">
                            <input type="hidden" name="tipo" value="<%= filtro %>">
                            <button class="btn" type="submit">⭐ GUARDAR RUTINA</button>
                        </form>
                    <% } %>
                </div>
            </div>
            <% } %>

        </div>
    </main>
</div>

</body>
</html>
