
% Funktiotiedostoa (DY) kutsutaan vaiheessa kolme
%% vaihe 1
% Vaiheessa 1 kuvataan kuulan putoamista 100 metriä korkean rakennuksen
% katolta. Tässä kohtaa ilmanvastusta ei ole vielä huomioitu. Kuvassa 1
% on esitetty kuulan korkeuksien kuvaajat ajan funktiona
% alkunopeuksien -5 m/s, 0 m/s sekä 5 m/s tapauksissa, kaikki samassa kuvassa. 
% Kuvassa 2 on esitetty kuulan nopeus ajan funktiona edellä mainittujen
% alkunopeuksien tapauksissa. 
clc
close all
clearvars

syms y(t)

g = 9.81;

funk(t) = diff(y,t,2) == -g; %Differentiaaliyhtälö, jossa ilmanvastusta ei ole huomioitu. Saadaan korkeus ajan suhteen
dfun = diff(y,t); %Saadaan nopeus ajan suhteen


% määritellään alkuarvot:
cond = ([y(0)==100 dfun(0)== -5]); % ensin korkeus, sitten nopeus
cond2 = ([y(0)==100 dfun(0)==0]) ;
cond3 = ([y(0)==100 dfun(0)== 5]);


%Ratkaistaan dsolvella, sijoitetaan alussa määritelty differentiaaliyhtälö sekä määritellyt alkuarvot:
kuulan_korkeus_hetkella_t1(t) = dsolve(funk,cond); %tapauksessa -5m/s
kuulan_korkeus_hetkella_t2(t) = dsolve(funk,cond2); %tapauksessa 0m/s
kuulan_korkeus_hetkella_t3(t) = dsolve(funk,cond3); %tapauksessa 5m/s


% piirretään korkeuksien kuvaaja:
fplot(kuulan_korkeus_hetkella_t1(t),[0 5]);
hold on
fplot(kuulan_korkeus_hetkella_t2(t),[0 5]);
fplot(kuulan_korkeus_hetkella_t3(t),[0 5]);
ylim([0 102]);
xlim([0 5.1]);
title('kuulan korkeus');
legend('korkeus, alkunopeuden ollessa -5m/s','korkeus, alkunopeuden ollessa 0m/s','korkeus, alkunopeuden ollessa 5m/s');
ylabel('korkeus');
xlabel('aika');

figure

%Seuraavaksi määritellään nopeus, kuulan nopeus tietyllä hetkellä saadaan derivoimalla sen korkeutta:
kuulan_nopeus_hetkella_t1(t) = diff(kuulan_korkeus_hetkella_t1(t)); 
kuulan_nopeus_hetkella_t2(t) = diff(kuulan_korkeus_hetkella_t2(t));
kuulan_nopeus_hetkella_t3(t) = diff(kuulan_korkeus_hetkella_t3(t));

% piirretään nopeuksien kuvaaja:
fplot(kuulan_nopeus_hetkella_t1(t), [0 5]);
hold on
fplot(kuulan_nopeus_hetkella_t2(t),[0 5]);
fplot(kuulan_nopeus_hetkella_t3(t),[0 5]);

title('kuulan nopeus');
legend('nopeus, alkunopeuden ollessa -5m/s','nopeus, alkunopeuden ollessa 0m/s','nopeus, alkunopeuden ollessa 5m/s');
ylabel('alkunopeus');
xlabel('aika');
hold off

%% vaihe2
% Vaiheessa 2 käydään läpi samat asiat kuin vaiheessa 1, mutta nyt
% kuvaajiin on huomioitu lisäksi ilmanvastuksen vaikutus. 

clc
close all
clearvars

syms y(t)

g = 9.81;
c = 0.5;
m = 6;

funk(t) = diff(y,t,2) == -g; %differentiaaliyhtälö, jossa ilmanvastusta ei ole huomioitu 
funk(t) = diff(y,t,2) == -g-(c/m)*diff(y,t); %differentiaaliyhtälö, jossa ilmanvastus on huomioitu 

derivoituna = diff(y,t); 

% määritellään alkuarvot:
cond4 = ([y(0)==100 derivoituna(0)== -5]); 
cond5 = ([y(0)==100 derivoituna(0)==0]) ;
cond6 = ([y(0)==100 derivoituna(0)== 5]);

%Ratkaistaan korkeus, kun ilmanvastusta ei huomioida:
kuulan_korkeus_hetkella_t1(t) = dsolve(funk,cond4); %tapauksessa -5m/s
kuulan_korkeus_hetkella_t2(t) = dsolve(funk,cond5); %tapauksessa 0m/s
kuulan_korkeus_hetkella_t3(t) = dsolve(funk,cond6); %tapauksessa 5m/s

%Ratkaistaan korkeus, kun ilmanvastus huomioidaan:
kuulan_korkeus_hetkella_t4(t) = dsolve(funk,cond4); %tapauksessa -5m/s
kuulan_korkeus_hetkella_t5(t) = dsolve(funk,cond5); %tapauksessa 0m/s
kuulan_korkeus_hetkella_t6(t) = dsolve(funk,cond6); %tapauksessa 5m/s

%piirretään korkeuden kuvaajat 
%punaisella: ilmanvastusta ei ole huomioitu
%sinisellä: ilmanvastus huomioitu

fplot(kuulan_korkeus_hetkella_t1(t),[0 5],'r','LineWidth',1);
hold on
fplot(kuulan_korkeus_hetkella_t2(t),[0 5],'r','LineWidth',2);
fplot(kuulan_korkeus_hetkella_t3(t),[0 5],'r','LineWidth',3);
fplot(kuulan_korkeus_hetkella_t4(t),[0 5], 'b','LineWidth',1);
fplot(kuulan_korkeus_hetkella_t5(t),[0 5], 'b','LineWidth',2);
fplot(kuulan_korkeus_hetkella_t6(t),[0 5],'b','LineWidth',3);
ylim([0 102]);
xlim([0 5.1]);
title('Kuulan korkeus');
legend('korkeus, alkunopeuden ollessa -5m/s','korkeus, alkunopeuden ollessa 0m/s','korkeus, alkunopeuden ollessa 5m/s','korkeus, alkunopeuden ollessa -5m/s','korkeus, alkunopeuden ollessa 0m/s','korkeus, alkunopeuden ollessa 5m/s','Location','southwest');
ylabel('korkeus');
xlabel('aika');
figure

%Seuraavaksi määritellään nopeus, kuulan nopeus tietyllä hetkellä saadaan derivoimalla sen korkeutta:
kuulan_nopeus_hetkella_t1(t) = diff(kuulan_korkeus_hetkella_t1(t)); 
kuulan_nopeus_hetkella_t2(t) = diff(kuulan_korkeus_hetkella_t2(t));
kuulan_nopeus_hetkella_t3(t) = diff(kuulan_korkeus_hetkella_t3(t));
kuulan_nopeus_hetkella_t4(t) = diff(kuulan_korkeus_hetkella_t4(t)); 
kuulan_nopeus_hetkella_t5(t) = diff(kuulan_korkeus_hetkella_t5(t));
kuulan_nopeus_hetkella_t6(t) = diff(kuulan_korkeus_hetkella_t6(t));

%piirretään nopeuden kuvaajat 
%punaisella: ilmanvastusta ei ole huomioitu
%sinisellä: ilmanvastus huomioitu

fplot(kuulan_nopeus_hetkella_t1(t), [0 5],'r','LineWidth',1);
hold on
fplot(kuulan_nopeus_hetkella_t2(t),[0 5],'r','LineWidth',2);
fplot(kuulan_nopeus_hetkella_t3(t),[0 5],'r','LineWidth',3);
fplot(kuulan_nopeus_hetkella_t4(t),[0 5],'b','LineWidth',1);
fplot(kuulan_nopeus_hetkella_t5(t),[0 5],'b','LineWidth',2);
fplot(kuulan_nopeus_hetkella_t6(t),[0 5],'b','LineWidth',3);
ylim([-55 5]);
xlim([0 5]);
title('Nopeuden kuvaaja');
legend('nopeus, alkunopeuden ollessa -5m/s','nopeus, alkunopeuden ollessa 0m/s','nopeus, alkunopeuden ollessa 5m/s','nopeus, alkunopeuden ollessa -5m/s','nopeus, alkunopeuden ollessa 0m/s','nopeus, alkunopeuden ollessa 5m/s','Location','southwest');
ylabel('alkunopeus');
xlabel('aika');
hold off



%% vaihe3
% Vaiheessa 3 tarkastellaan tarkemmin alkunopeuden 5 m/s vastaavaa tilannetta ilmanvastus huomioitaessa
% Kuvaajasta ilmenee sen maksimikorkeus(vihreä piste) sekä ajanhetki,
% jolloin kuula osuu maahan (musta piste).
% Tehtävä on ratkaistu ode45 funktiota käyttäen. 
% Pääohjelma kutsuu funktiotiedostoa.

clc
close all
clearvars


%Ratkaistaan differentiaaliyhtälö funktion ode45 avulla kun ilmanvastus on
%huomioitu ja alkunopeus on 5m/s. Kutsutaan funktiotiedostoa DY.
c = 0.5 ;
m = 6 ;
g = 9.81 ;
y0 = [100 5] ;
tspan = [0 5.348] ;
[T,Y] = ode45(@(t,y) DY(t,y,c,m,g), tspan, y0) ;

% Piirretään kuvaaja pallon korkeudesta ajan suhteen:

plot(T,Y(:,1),'m')
hold on
ylim([0 105]);

% Ratkaistaan pallon maksimikorkeus -> lisätään vihreä piste kuvaan

maksimi = max(Y(:,1)) ;
maksimi_y = find(Y == maksimi) ;
plot(T(maksimi_y), maksimi, 'go','linewidth',5)

% Selvitetään ajanhetki, jolloin kuula osuu maahan -> lisätään musta piste kuvaan

osuu_maahan = find(Y(:,1) <= 0);
ajanhetki = T(osuu_maahan)
plot(ajanhetki, 0, 'ko','linewidth',5);

% Kuvaajan tiedot:

title('Kuvaaja pallon lentokaaresta, mukana maksimikorkeus sekä hetki jolloin osuu maahan, alkunopeus 5m/s')
legend('kaari','maksimi','minimi')
ylabel('korkeus, (m)')
xlabel('aika, (s)')
hold off

%% vaihe4
% toistetaan vaihe 3 dsolve funktiolla.
clc
close all
clearvars

%Ratkaistaan differentiaaliyhtälö funktion dsolve avulla kun ilmanvastus on
%huomioitu ja alkunopeus on 5m/s 

c = 0.5;
m = 6;
g = 9.81;

syms y(t)
eqn = diff(y,t,2) + c/m * diff(y,t) + g;
dy = diff(y,t);
cond = [y(0) == 100, dy(0) == 5];
ysol(t) = dsolve(eqn,cond);

% Piirretään kuvaaja pallon korkeudesta ajan suhteen:
fplot(ysol(t), 'm') ;
hold on
xlim([0 6]) ;
ylim([0 105]) ;

% Ratkaistaan pallon maksimikorkeus -> lisätään vihreä piste kuvaan

derivaatta = diff(ysol(t));
maksimi = solve(derivaatta == 0,t) ;
max_y = double((ysol(maksimi))) ;
plot(maksimi, max_y,'go','linewidth',5);

% Selvitetään ajanhetki, jolloin kuula osuu maahan -> lisätään musta piste kuvaan:
ajanhetki = double(solve(ysol(t) == 0))
plot(ajanhetki,0,'ko','linewidth',5);

% Kuvaajan tiedot

title('Kuvaaja pallon lentokaaresta, mukana maksimikorkeus sekä hetki jolloin osuu maahan, alkunopeus 5m/s')
legend('kaari','maksimi','minimi')
ylabel('korkeus, (m)')
xlabel('aika, (s)')

%% vaihe5
% Vaiheessa 5 on animaatio kuulan putoamisesta. Samasta kuvaajasta löytyvät
% sekä tapaus, jossa ilmanvastusta ei huomioida, että tapaus, jossa
% ilmanvastus on huomioitu. 
% Kuvaajaan on lisäksi merkitty maanpinta havainnollistamaan mittasuhteita ja putoamista.

clc
close all
clearvars

syms y(t)
g=9.81;
c=0.5;
m=6;

%putoamisen funktiot (ilmanvastukseton ja -vastuksellinen):
funk(t) = diff(y,t,2) == -g; %ilmanvastukseton
funk(t) = diff(y,t,2) == -g-(c/m)*diff(y,t); %ilmanvastuksellinen
derivoituna = diff(y,t) % funktiot derivoituna

%valitaan satunnainen alkutilanne: alkukorkeudeksi tässä on valittu 20m ja
%alkunopuedeksi 0
alkutilanne1 = ([y(0)==20 derivoituna(0)==0]); 

% Ratkaistaan hyödyntämällä dsolve funktiota
vastuksetonf(t) = dsolve(funk,alkutilanne1); % tapaus, jossa ilmanvastusta ei huomioida
vastuksellinenf(t) = dsolve(funk, alkutilanne1); % tapaus, jossa ilmanvastus huomioidaan

%ennen for-looppia esitetään piirtokomennot ja kuvaajan tiedot
kuula1 = plot(0.5, 20, 'om','LineWidth',5); %ilmanvastukseton kuula
hold on
kuula2 = plot(1.5, 20, 'og','LineWidth',5); %ilmanvastuksellinen kuula

title('Kuulien pudottaminen 20 metrin korkeudesta');
plot([0 2], [0 0],'k','LineWidth',5);
legend('ilmanvastukseton','ilmanvastuksellinen','maanpinta');
ylabel('korkeus');
xlabel('x-akseli');
ylim([-5 30]);
xlim([0 2]);
 

%for-loopissa plotattuna molempien kuulien korkeus välillä 0-inf
%Kuulat jatkavat putoamista maanpinnasta huolimatta.
for i = 0:0.01:inf
    korkeus_nopein = vastuksetonf(i);
    kuula1.YData = (korkeus_nopein);
    kuula2.YData = (vastuksellinenf(i));
    hold off
    pause(0.01)
end
    
%% vaihe 6
% Tarkastellaan ammutun kuulan lentorataa.
% Kuulan alkunopeus 200 m/s ja lähtökulma 45◦

clc
close all
clear vars

syms y(t)
g=9.81;
c=0.5;
m=6;

funk(t) = diff(y,t,2) == -g; % vaihe1 funktio, jossa ilmanvastusta ei ole huomioitu 
funk(t) = diff(y,t,2) == -g-(c/m) * diff(y,t) ; % vaihe2 funktio, ilmanvastuksellinen

% Aloituskulma 45 astetta
heittoliike1(t) = diff(y,t,2) == tan(45) ;
heittoliike2(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(45) ;

dfun = diff(y,t) ; % derivoidaan funktiot: saadaan nopeus

cond = ([y(0) == 0 dfun(0) == 200]) ; % alkukorkeus ja alkunopeus

% vastukseton putoamisliike, heittoliike
pysty1(t) = dsolve(funk,cond) ;
vaaka1(t) = dsolve(heittoliike1,cond) ; 
%
% ilmanvastuksellinen putoamisliike, heittoliike
pysty2(t) = dsolve(funk,cond) ;
vaaka2(t) = dsolve(heittoliike2,cond) ; 

kuula1 = plot(1.5, 20, 'om', 'LineWidth',5) % ilmanvastukseton kuula
hold on
kuula2 = plot(1.5, 20, 'og', 'LineWidth',5) %ilmanvastuksellinen kuula
title('Kuulan heittorata')
plot([0 7000], [0 0], 'k', 'LineWidth', 5)
legend('ilmanvastukseton','ilmanvastuksellinen', 'maanpinta')
ylabel('korkeus')
xlabel('maanpinta')
ylim([-100 3000]) 
xlim([0 7000]) 

% for loopissa plotattuna molempien kuulien korkeus välillä 0-inf 
% Kuulat jatkavat putoamista maanpinnasta huolimatta

for i = 0:0.1:inf
    kuula1.XData = vaaka1(i)
    kuula1.YData = pysty1(i)
    kuula2.XData = vaaka2(i)
    kuula2.YData = pysty2(i)
    hold off
    pause(0.1)
end

%% vaihe 7
clc
clearvars
close all

syms y(t)
g=9.81;
c=0.5;
m=6;

funk(t) = diff(y,t,2) == -g-(c/m) * diff(y,t) ; % vaihe2 funktio, ilmanvastuksellinen

% integraalit, jossa aloituskulmat 15/30/45/60 astetta
heittoliike15(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(15) ;
heittoliike30(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(30) ;
heittoliike45(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(45) ;
heittoliike60(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(60) ;

dfun = diff(y,t) ; % derivoidaan dunktiot: saadaan nopeus

cond = ([y(0) == 0 dfun(0) == 200]) ; % alkukorkeus ja alkunopeus

% ilmanvastuksellinen putoamisliike, heittoliike
pysty(t) = dsolve(funk,cond) ;

vaaka15(t) = dsolve(heittoliike15,cond) ; 
vaaka30(t) = dsolve(heittoliike30,cond) ; 
vaaka45(t) = dsolve(heittoliike45,cond) ; 
vaaka60(t) = dsolve(heittoliike60,cond) ; 

kuula15 = plot(1.5, 20, 'or', 'LineWidth',5)
hold on
kuula30 = plot(1.5, 20, 'om', 'LineWidth',5)
kuula45 = plot(1.5, 20, 'og', 'LineWidth',5) 
kuula60 = plot(1.5, 20, 'oy', 'LineWidth',5) 

title('Kuulan heittorata')
plot([0 7000], [0 0], 'k', 'LineWidth', 5)
legend('kuula_15','kuula_30', 'kuula_45', 'kuula_60', 'maanpinta')
ylabel('korkeus')
xlabel('maanpinta')
ylim([-100 3000]) 
xlim([0 7000]) 

% for loopissa plotattuna molempien kuulien korkeus välillä 0-inf 
% Kuulat jatkavat putoamista maanpinnasta huolimatta

for i = 0:0.1:inf
    kuula15.XData = vaaka15(i)
    kuula15.YData = pysty(i)
    
    kuula30.XData = vaaka30(i)
    kuula30.YData = pysty(i)
    
    kuula45.XData = vaaka45(i)
    kuula45.YData = pysty(i)
    
    kuula60.XData = vaaka60(i)
    kuula60.YData = pysty(i)
    hold off
    pause(0.1)
end
%% vapaaehtoinen osio

%% vaihe 8
% Vaihe 8 on pitkälti samanlainen kuin vaihe 5. Nyt for-loopissa sekä
% kuvaajassa on kuitenkin huomiotu ajanhetki, jolloin kuulat koskettavat
% maanpintaa. 

clc
close all
clearvars

syms y(t)
g=9.81;
c=0.5;
m=6;

%putoamisen funktiot (ilmanvastukseton ja -vastuksellinen):
funk(t) = diff(y,t,2) == -g;  %ilmanvastukseton
funk(t) = diff(y,t,2) == -g-(c/m)*diff(y,t); %ilmanvastuksellinen
derivoituna = diff(y,t) % funktiot derivoituna

%valitaan satunnainen alkutilanne --> sama kuin vaiheessa 5
alkutilanne1 = ([y(0)==20 derivoituna(0)==0]); 

% Ratkaistaan hyödyntämällä dsolve funktiota
vastuksetonf(t) = dsolve(funk,alkutilanne1); %tapaus, jossa ilmanvastusta ei huomioida
vastuksellinenf(t) = dsolve(funk, alkutilanne1); % %tapaus, jossa ilmanvastus huomioidaan

%ennen for-looppia piirtokomennot ja kuvaajan tiedot
kuula1 = plot(0.5, 20, 'om','LineWidth',5); %ilmanvastukseton
hold on
kuula2 = plot(1.5, 20, 'og','LineWidth',5); %ilmanvastuksellinen

title('Kuulien pudottaminen 20 metrin korkeudesta');
plot([0 2], [0 0],'k','LineWidth',5);
legend('ilmanvastukseton','ilmanvastuksellinen','maanpinta');
ylabel('korkeus');
xlabel('kuula maanpinnalla');
ylim([-1 30]);
xlim([0 2]);


%for-loopissa plotattuna molempien kuulien korkeus välillä 0-inf
%looppi katkeaa kun hitaampi kuula(ilmanvastuksellinen) osuu maahan
for i = 0:0.01:inf
    korkeus_nopein = vastuksetonf(i);
    if vastuksellinenf(i)<0
        kuula1.YData = (0);
        break
    end
    if vastuksetonf(i) < 0
        korkeus_nopein = 0;
    end
    kuula1.YData = (korkeus_nopein);
    kuula2.YData = (vastuksellinenf(i));
    hold off
    pause(0.01)
end
  
%% vaihe 9
% Muutetaan vaiheen 7 animaatio niin, että kuulat pysähtyvät maanpintaan.
clc
clearvars
close all

syms y(t)
g=9.81;
c=0.5;
m=6;

funk(t) = diff(y,t,2) == -g-(c/m) * diff(y,t) ; % vaihe2 funktio, ilmanvastuksellinen

% integraalit, jossa aloituskulmat 15/30/45/60 astetta
 heittoliike15(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(15) ;
heittoliike30(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(30) ;
heittoliike45(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(45) ;
heittoliike60(t) = diff(y,t,2) + (c/m) * diff(y,t) == tan(60) ;

dfun = diff(y,t) ; % derivoidaan dunktiot: saadaan nopeus

cond = ([y(0) == 0 dfun(0) == 200]) ; % alkukorkeus ja alkunopeus

% ilmanvastuksellinen putoamisliike, heittoliike
pysty(t) = dsolve(funk,cond) ;

vaaka15(t) = dsolve(heittoliike15,cond) ; 
vaaka30(t) = dsolve(heittoliike30,cond) ; 
vaaka45(t) = dsolve(heittoliike45,cond) ; 
vaaka60(t) = dsolve(heittoliike60,cond) ; 

kuula15 = plot(1.5, 20, 'or', 'LineWidth',5)
hold on
kuula30 = plot(1.5, 20, 'om', 'LineWidth',5)
kuula45 = plot(1.5, 20, 'og', 'LineWidth',5) 
kuula60 = plot(1.5, 20, 'oy', 'LineWidth',5) 

title('Kuulan heittorata')
plot([0 7000], [0 0], 'k', 'LineWidth', 5)
legend('kuula_15','kuula_30', 'kuula_45', 'kuula_60', 'maanpinta')
ylabel('korkeus')
xlabel('maanpinta')
ylim([-100 3000]) 
xlim([0 7000]) 

% for loopissa plotattuna molempien kuulien korkeus välillä 0-inf 
% Kuulat jatkavat putoamista maanpinnasta huolimatta

for i = 0:1:inf
    kuula15.XData = vaaka15(i)
    kuula15.YData = pysty(i)
        if kuula15.YData <= -0.1
        break
    end
    kuula30.XData = vaaka30(i)
    kuula30.YData = pysty(i)
        if kuula30.YData <= -0.1
        break
    end
    kuula45.XData = vaaka45(i)
    kuula45.YData = pysty(i)
        if kuula45.YData <= -0.1
        break
    end
    kuula60.XData = vaaka60(i)
    kuula60.YData = pysty(i)
        if kuula60.YData <= -0.1
        break
    end
    
    hold off
    pause(0.01)
end
