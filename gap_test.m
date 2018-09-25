%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Monte Carlo módszerek, 2013 tavasz, félévközi házi feladat
% feladat sorszama: 1.
% "pi jegyeinek vizsgalata pszeudo-veletlenszamkent valo hasznalhatosaguknak szempontjabol
% Berczédi Balázs
% BGGUER
% 2013-04-21

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tablazat] = gap_test_BGGUER(khi2proba_szam)

global file_azonosito           % pi jegyeit tartalmazo txt fajl eleresehez
global index                    % szamjegyek beolvasasanak tombositese soran hasznalt valtozo
global veletlen_vektor          % "beolvas" darab pi jegyeibol generalt veletlenszamot tartalmazo vektor
global beolvas                  % egyzerre ennyi veletlanszamot generalunk pi.txt-bol (sebesseg novelese erdekeben)

file_azonosito = fopen('pi.txt','rt');      % olvasasra megnyitjuk pi.txt-t



%-------------------------------------------------------------
% a feladatkiirasban szereplo valtoztathato parameterek: 

s=6;                    % generalt veletlanszam tizedesjegyeinek szama

n=1000;                 % egy proba soran megszamolt hezagok szama
t=5;                    % ez alatt az ertek alatt a hezagszamokat kulon kategoriakba soroljuk,
                        % ettol az ertektol felfele egy kozos kategoriaba soroljuk oket
                        % (azaz khi2 proba szadsagfoka)

a=0.1;                  % hezag proba intervallumanak also hatara
b=0.3;                  % hezag proba intervallumanak felso hatara

%-------------------------------------------------------------



beolvas=10000;          % gyorsabb beolvasas erdekeben egyszerre ennyi veletlenszamot generalunk pi.txt-bol
index=beolvas;          % azert, hogy a tombositett beolvasas miatt az egymas utan vegzett probak soran se 
                        % veszitsunk el szamjegyeket, szukseg van az "index" globalis valtozora ami szamontartja,
                        % hogy hany darabot hasznaltunk el a korabban beolvasott, a szinten globalis
                        % "veletlen_vektor" -ban tarolt veletlenszamokbol 


elmelet=zeros(t+1,1);   % hezag proba elmeleti gyakorisag adatainak tarolasara
p = b - a ;             % kituntetett intervallumba eses valoszinusege

% elmeleti gyakorisagok kiszamitasa:

elmelet(1,1) = p;                       % 0-hosszu hezag valoszinusege
for iii = 1:t-1
    elmelet(iii+1,1) = p*(1-p)^iii;     % 1 - (t-1) hosszu hezagok valoszinusege
end
elmelet(t+1,1) = (1-p)^t;               % legalabb t hosszu hezagok valoszinusege

elmelet = elmelet * n;                  % valoszinusegekbol meghatarozott elmeleti gyakorisag ertekek

khi2ertekek = zeros(1,khi2proba_szam);          % khi2 probak ertekeinek tarolasara


tic     % merjuk az idot is

for iii = 1: khi2proba_szam     % bemeno parameterkent megkapott szamu khi2 proba elvegzese az alfuggvenykent megirt hezag probara
                                % es a szinten alfuggenykent megirt khinegyzet_ertek hasznalataval 
    
    gyakorlat = kiserlet_sorozat(n,t,a,b,s);
    khi2ertekek(1,iii) = khinegyzet_ertek(elmelet,gyakorlat);
    
end

disp(' ');
toc                 % eltelt idot kiiratasa
disp(' ');


fclose(file_azonosito);         % innentol mar nincs szukseg a txt fajlra


%forraskodban rogzitett adatok kiirasahoz szukseges:

n_string = num2str(n);                      
t_string = num2str(t);
a_string = num2str(a,4);
b_string = num2str(b,4);
s_string = num2str(s);
khi2_string = num2str(khi2proba_szam);

disp(horzcat('n=', n_string, '    t=', t_string, '    a=', a_string, '    b=', b_string, '    s=', s_string));
disp(' ');
disp(horzcat(khi2_string, ' db proba khi2 ertekeinek tapasztalt eloszlasa: '));



rendezve = sort(khi2ertekek);       % tapasztalt inverz khi2 eloszlas meghatarozasa

tablazat = zeros(2,7);

% eredmenyek az oran kiadott khi2 tablazattal egyszeruen osszevetheto formaban:

tablazat(1,1) = 01;
tablazat(1,2) = 05;
tablazat(1,3) = 25;
tablazat(1,4) = 50;
tablazat(1,5) = 75;
tablazat(1,6) = 95;
tablazat(1,7) = 99;

tablazat(2,1) = rendezve(ceil(khi2proba_szam*0.01));
tablazat(2,2) = rendezve(ceil(khi2proba_szam*0.05));
tablazat(2,3) = rendezve(ceil(khi2proba_szam*0.25));
tablazat(2,4) = rendezve(ceil(khi2proba_szam*0.50));
tablazat(2,5) = rendezve(ceil(khi2proba_szam*0.75));
tablazat(2,6) = rendezve(ceil(khi2proba_szam*0.95));
tablazat(2,7) = rendezve(ceil(khi2proba_szam*0.99));


% tapasztalt inverz khi2 eloszlas abrazolasa:
subplot(2,1,1)
plot((1:khi2proba_szam)/khi2proba_szam,rendezve,'b.');
title(horzcat('n=', n_string, ',    t=', t_string, ',    a=', a_string, ',    b=', b_string, ',   s=', s_string, ',     ', khi2_string, 'db próba'));
legend('inverz khi2 eloszlas');

% tapasztalt khi2 eloszlas es lemeleti khi2 eloszlas abrazolsa egy grafikonon:
subplot(2,1,2)
hold on
plot(rendezve,(1:khi2proba_szam)/khi2proba_szam,'b');       % tapasztalati khi2 eloszlas kek szinnel

x=linspace(0,max(rendezve));
plot(x,chi2cdf(x,t),'r');                   % megfelelo szabadsagfoku elmeleti khi2 eoloszlas pirossal
legend('tapasztalt khi2 eloszlás', 'elméleti khi2 eloszlas');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bemeno parameterkent kapott elmeletileg vart es gyakorlatilag tapasztalt
% gyakorisagokbol khi2 erteket szamolo fuggveny

function [khi2] = khinegyzet_ertek(elmelet, gyakorlat)

khi2 = sum((gyakorlat - elmelet).^2./elmelet);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% az alfuggvenykent megirt "veletlenszam generatort" 's' jeggyel hasznalva hezag probat
% vegzunk a bemeno parameterkent kapott (n,t,a,b) ertekekkel
% kimeno 'hossz' parametervektor tartalmazza az 'n' db hezag eloszlasat:
% '1.' - 't.' elemei egyenkent a '0' - 't-1' hosszu hezagok, 't+1.' eleme a legalabb
% 't' hosszu hezagok tapasztalt szamat tartalmazza

function [hossz] = kiserlet_sorozat(n,t,a,b,s)

global index                % a tombositett, de folytonos beolvasahoz
global beolvas              % ennyi szamot generalunk egyszerre
global veletlen_vektor      % a pi jegyeibol generalt veletlenszamokat tartamazza
                            % ha kozben a vegere ertunk, ujra ebbe olvasunk be szamokat


hossz = zeros(t+1,1);       % '0' - 't-1' illetve legalabb 't' hosszu hezagok

megszamolt_hezag = 0;       % probankent 'n' hezagig szamolunk majd
r = 0;                      % hezag hossza

while (megszamolt_hezag < n)    % egy proba soran 'n' db hezagot szamlalunk
    
    index = index+1;            % a kovetkezo "veletlen" szamra lepunk
    
    if index == beolvas + 1;                        % kiveve, ha elfogytak
        veletlen_vektor = generator(s,beolvas);     % ekkor 'beolvas' db-ot olvasunk be
        index = 1;                                  % es az elso sorszamut hasznaljuk eloszor
    end
    
    % hezag hosszanak meghatarozasa:
    
    if (veletlen_vektor(index,1)>=a)&&(veletlen_vektor(index,1)<=b)     % a kituntetett intervallumba esik a szam, a hezag vegere ertunk

        if r < t                                        % 't'-nel rovidebb hezag: hossz szerint kulon-kulon szamontartjuk oket
            hossz(r+1,1) = hossz(r+1,1) + 1;
            
        else                                            % legalabb 't' hosszu hezag: eggyuttes szamukat hatarozzuk meg
            hossz(t+1,1) = hossz(t+1,1) + 1;
            
        end
        
        r=0;                                            % ujrakezdjuk a szamolast
        megszamolt_hezag = megszamolt_hezag + 1;        % elkonyveljuk, hogy egy ujabb hezagot megszamoltunk
        
    else                % nem a kituntetett intervallumba esik a szam, a hezag nem ert meg veget
        r = r + 1;      % hezag hossza tovabb no 1-gyel
        
    end
        
end         % a while ciklus lefutasa utan a 'hossz' vektor tartalmazza a hezagok hossz szerinti eloszlasat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a feladatkiirasban szereplo tizedesjegyekbol 0-1 koze eso szamot generalo
% algoritmus
% bemeno parameterek:
% s - tizedesjegyek szama
% n - generalt szamok szama (n=1 eseten 1 db 's' tizedesjegybol allo [0,1[-on elhelyezedo szamot ad vissza)
% kimeno parameter:
% B - a generalt szam

function [B]=generator(s,n)

global file_azonosito   % mindig ugyanabbol a fajlbol olvassuk az egymas utai tizedesjegyeket

[A,szamlalo] = fscanf(file_azonosito,strcat('%',int2str(s),'d'),n);     % beolvasunk n*s jegyet es 
                                                                        % eloallitunk 'n' db egesz szamot amik 'A' vektorba kerulnek  

% ha az aktualis lepesben mar nem lehet eleg szamjegyet beolvasni:
if (szamlalo ~= n) error( 'A PI JEGYEI ELFOGYTAK A TXT FAJLBOL'); end

% egyebkent az 'n' db 's' jegyu egesz szambol 'n' db 's' jegyu [0,1[ intervallumon
% levo tizedestortet keszitunk a 'B' vektroba:
B=A*10^(-s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
