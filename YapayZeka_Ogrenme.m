image=imread('C:\Users\�MERTURGUT\Desktop\Nesnelerr.PNG'); %Resmi Okuma
figure(1), imshow(image);  %Resmi G�sterme

imagegray=rgb2gray(image); %Resim gri tona d�nd�r�l�yor.
figure(2), imshow(imagegray);
level=graythresh(imagegray); %Parlakl�k e�i�i belirlendi ve 0 ile 1 aras�nda say� olu�turuldu.
bw=im2bw(imagegray,0.4); % Resim tamamen siyah-beyaz piksellere d�n��t�.
figure(3),imshow(bw); 

bw=bwareaopen(bw,30);    %30px den daha az say�da olan nesneler kald�r�l�yor.
figure(8),imshow(bw);

se=strel('disk',20); %Yar��ap� 10px olan disk bi�iminde yap�sal element olu�turuyoruz.
bw=imclose(bw,se); %Yap�sal element yard�m�yla i� k�s�mdaki bo�luklar kayboldu.
figure(4),imshow(bw);

bw=imfill(bw,'holes'); %Resimde �ukur diye nitelendirilen yerleri dolduruyoruz.
figure(5), imshow(bw);

[B,L] = bwboundaries(bw,'noholes');disp(B)
figure(6), imshow(label2rgb(L, @jet, [.5 .5 .5]))

hold on
for k = 1:length(B)
  boundary = B{k}; %'k' etiketindeki nesnenin s�n�r kordinatlar�n� (X,Y) belirler;
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
fprintf('Nesneler i�aretlenmi�tir. Toplam Nesne Say�s�=%d\n',k)

stats = regionprops(L,'Area','Centroid'); 

% Nesneleri sayan loopun ba�lang�c�
for k = 1:length(B)
 
  % 'k' etiketindeki nesnenin s�n�r kordinatlar�n� (X,Y) belirler
  boundary = B{k};
 
  % Nesnenin �evresini hesaplar
  delta_sq = diff(boundary).^2;
  perimeter = sum(sqrt(sum(delta_sq,2)));

  % 'k' etiketli nesnenin alan�n� hesaplar
  area = stats(k).Area;
 
  % Nesnenin metric de�erini hesaplar
  metric = 4*pi*area/perimeter^2;
 
  % Hesaplanan de�eri g�sterir
  metric_string = sprintf('%2.2f',metric);
  centroid = stats(k).Centroid;
 
  if metric > 0.9191  %E�er metric de�er e�ik de�erden daha b�y�k ise yuvarlak nesne kabul edilir.
    text(centroid(1),centroid(2),'�ember');
 
  elseif (metric <= 0.8693) && (metric >= 0.8241)
    text(centroid(1),centroid(2),'Dikd�rgen');
  else
     text(centroid(1),centroid(2),'Belirlenemeyen �ekil');
  end
  
disp(metric)
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold');
  
end
fprintf('Nesneler i�aretlenmi�tir. Toplam Nesne Say�s�=%d\n',k)