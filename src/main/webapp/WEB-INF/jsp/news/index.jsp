<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

Available News:
<table class="table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Titel</th>
            <th>letzter Autor</th>
            <th>Zuletzt ge�ndert am</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${nodes}" var="node">    
            <tr>
                <td>${node.id}</td>
                <td><a href="/news/${node.id}/">${node.title}</a></td>
                <td>${empty node.author.login ? "unbekannt" : node.author.login}</td>
                <td>${empty node.updated ? node.created : node.updated}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>