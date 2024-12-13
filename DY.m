function dydt = DY(t,y,c,m,g)

% Komento dydt = DY(a,b) laskee differentiaaliyhtälöryhmän parametrien c, m ja g
% eri arvoilla ja tallentaa sen muuttujaan dydt, joka palautetaan käyttäjälle.

dydt = zeros(2,1) ;
dydt(1) = y(2) ;
dydt(2) = (-c/m)*y(2)-g ;

end

