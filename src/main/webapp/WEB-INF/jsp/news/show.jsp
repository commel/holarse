<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/security/tags" %>

<h1>
    ${node.title}
    <small class="text-muted">${node.subtitle}</small>
</h1>

<div class="row justify-content-between">
    <div class="col-4">
        <nav class="nav holarse-tags">

            <li class="nav-item">
                <a class="nav-link" href="#" title="Klicken f�r weitere Artikel mit diesem Tag">Spiele</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#">Kommerziell</a>

            </li>                
            <li class="nav-item">
                <a class="nav-link" href="#">native</a>
            </li>                                
            <li class="nav-item">
                <a class="nav-link" href="#">Steam</a>
            </li>                                
            <li class="nav-item">
                <a class="nav-link" href="#">Shooter</a>
            </li>    
        </nav>
    </div>
    <div class="col-4">
        <nav class="nav holarse-node-menu">
            <li class="nav-item">
                <a class="nav-link" href="${node.url}/edit">Bearbeiten</a>    
            </li>
            <s:authorize access="hasAnyRole('MODERATOR', 'ADMIN')">            
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Artikelmen�</a>
                    <div class="dropdown-menu">
                        <a class="nav-link" href="${node.url}/edit">Bearbeiten</a>    
                        <a class="dropdown-item" href="${node.url}/delete">L�schen</a>
                    </div>            
                </li>
            </s:authorize>            
            <li class="nav-item">
                <a class="nav-link" href="${node.url}/revisions">Revisionen</a>    
            </li>
            <span class="navbar-text">Letzte �nderung: ${empty node.updated ? node.created : node.updated} durch ${empty node.author ? 'unbekannt' : node.author.login}</span>                
        </nav>
    </div>    
</div>


<div class="row">
    <div class="col-md-8">
        ${node.content}    
    </div>
    <div class="col-md-4">
        <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
                <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
            </ol>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img class="d-block w-100" src="https://placeimg.com/640/480/any" alt="First slide">
                    <div class="carousel-caption d-none d-md-block">
                        <p>Screenshot aus der Beta</p>
                    </div>                    
                </div>
                <div class="carousel-item">
                    <img class="d-block w-100" src="https://placeimg.com/640/480/any" alt="Second slide">
                    <div class="carousel-caption d-none d-md-block">
                        <p>Selbstgemachter Screenshot</p>
                    </div>                    
                </div>
                <div class="carousel-item">
                    <img class="d-block w-100" src="https://placeimg.com/640/480/any" alt="Third slide">
                    <div class="carousel-caption d-none d-md-block">
                        <p>Produktbild</p>
                    </div>
                </div>
            </div>
            <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>
            <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
        </div>        

        <div class="embed-responsive embed-responsive-16by9">
            <iframe class="embed-responsive-item" src="https://www.youtube-nocookie.com/embed/zpOULjyy-n8?rel=0" allowfullscreen></iframe>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/jspf/comments/list.jspf" %>


<div class="row">
    <div class="col-md-12">

        <%@include file="/WEB-INF/jspf/comments/form.jspf" %>

    </div>
</div>