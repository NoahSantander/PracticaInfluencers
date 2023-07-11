% 1
canal(ana, youtube, 3000000).
canal(ana, instagram, 2700000).
canal(ana, tiktok, 1000000).
canal(ana, twitch, 2).
canal(beto, twitch, 120000).
canal(beto, youtube, 6000000).
canal(beto, instagram, 1100000).
canal(cami, tiktok, 2000).
canal(dani, youtube, 1000000).
canal(evelyn, instagram, 1).

usuario(ana).
usuario(beto).
usuario(cami).
usuario(dani).
usuario(evelyn).

% 2.a
% obtenerSeguidores/2 Saber que cantidad de seguidores tiene un usuario en total
obtenerSeguidores(Usuario, CantSeguidores):-
    usuario(Usuario),
    findall(Seguidores, canal(Usuario, _, Seguidores), ListaSeguidores),
    sumlist(ListaSeguidores, CantSeguidores).
    

% influencer/1 Saber si un usuario tiene mas de 10000 seguidores entre todas sus redes
influencer(Usuario):-
    obtenerSeguidores(Usuario, CantSeguidores),
    CantSeguidores > 10000.

% 2.b
obtenerTodasLasRedes(Redes):-
    findall(Red, canal(_, Red, _), ListaTotalRedes),
    list_to_set(ListaTotalRedes, Redes).

% tieneTodasLasRedes/1 Saber si un usuario tiene todas las redes
tieneTodasLasRedes(Usuario):-
    findall(Red, canal(Usuario, Red, _), ListaRedes),
    obtenerTodasLasRedes(RedesTotales),
    intersection(RedesTotales, ListaRedes, Interseccion),
    intersection(Interseccion, RedesTotales, RedesTotales).

% omnipresente/1 Si un influencer esta en todas las redes sociales
omnipresente(Usuario):-
    influencer(Usuario),
    tieneTodasLasRedes(Usuario).
    
% 2.c
% tieneMasDeUnaRed/1 Saber si un usuario tiene mas de una red
tieneMasDeUnaRed(Usuario):-
    canal(Usuario, Red1, _),
    canal(Usuario, Red2, _),
    Red1 \= Red2.

% exlusivo/1 Un influencer esta en una única red
exclusivo(Usuario):-
    influencer(Usuario),
    not(tieneMasDeUnaRed(Usuario)).

% 3.a
publicacion(ana, tiktok, video(1, [beto, evelyn])).
publicacion(ana, tiktok, video(1, [ana])).
publicacion(ana, instagram, foto([ana])).
publicacion(beto, instagram, foto([])).
publicacion(cami, twitch, stream(leagueOfLegends)).
publicacion(cami, youtube, video(5,[cami])).
publicacion(evelyn, instagram, foto([evelyn, cami])).

% 3.b
tematica(juegos, [leagueOfLegends, minecraft, aoe]).

% 4
% esAdictivo/1 Saber si una red social es adictiva
esAdictivo(video(Duracion, _)):-
    Duracion < 3.

esAdictivo(stream(Tematica)):-
    tematica(juegos, Tematicas),
    member(Tematica, Tematicas).

esAdictivo(foto(Participantes)):-
    length(Participantes, CantParticipantes),
    CantParticipantes < 4.
    
% adictiva/1 Saber si una red solo tiene contenidos adictivos
adictiva(Red):-
    publicacion(_ , Red, _),
    forall(publicacion(_, Red, Contenido), esAdictivo(Contenido)).

% 5
% apareceEnLaPublicacion/2 Saber si un usuario aparece en la publicacion
apareceEnLaPublicacion(Usuario, foto(Participantes)):-
    member(Usuario, Participantes).

apareceEnLaPublicacion(Usuario, video(_, Participantes)):-
    member(Usuario, Participantes).

apareceEnLaPublicacion(_, stream(_)).

% colaboran/2 Saber si un usuario aparece en las redes de otro 
colaboran(UsuarioOkupa, UsuarioInvadido):-
    publicacion(UsuarioInvadido, _, Publicacion),
    apareceEnLaPublicacion(UsuarioOkupa, Publicacion).

% 6
% caminoALaFama/1 Saber si un usuario no influencer aparece en la publicacion de un usuario influencer o el influencer publicó contenido donde aparece otro usuario que a su vez publicó contenido donde aparece el usuario
participoInfluencer(Usuario, Influencer):-
    colaboran(Usuario, Influencer).

participoInfluencer(Usuario, Influencer):-
    not(colaboran(Usuario, Influencer)),
    colaboran(AmigoInfluencer, Influencer),
    participoInfluencer(Usuario, AmigoInfluencer).

caminoALaFama(Usuario):-
    publicacion(Usuario, _, _),
    not(influencer(Usuario)),
    influencer(Influencer),
    participoInfluencer(Usuario, Influencer).

% 7.b
% No se tuvo que hacer nada por Principio de Universo Cerrado. Como no aparece que beto tenga tikto en mi base de conocimiento, entonces que beto tenga tiktok es falso.