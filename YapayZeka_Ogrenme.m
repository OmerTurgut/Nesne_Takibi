image=imread('C:\Users\ÖMERTURGUT\Desktop\Nesnelerr.PNG'); %Resmi Okuma
figure(1), imshow(image);  %Resmi Gösterme

imagegray=rgb2gray(image); %Resim gri tona döndürülüyor.
figure(2), imshow(imagegray);
level=graythresh(imagegray); %Parlaklýk eþiði belirlendi ve 0 ile 1 arasýnda sayý oluþturuldu.
bw=im2bw(imagegray,0.4); % Resim tamamen siyah-beyaz piksellere dönüþtü.
figure(3),imshow(bw); 

bw=bwareaopen(bw,30);    %30px den daha az sayýda olan nesneler kaldýrýlýyor.
figure(8),imshow(bw);

se=strel('disk',20); %Yarýçapý 10px olan disk biçiminde yapýsal element oluþturuyoruz.
bw=imclose(bw,se); %Yapýsal element yardýmýyla iç kýsýmdaki boþluklar kayboldu.
figure(4),imshow(bw);

bw=imfill(bw,'holes'); %Resimde çukur diye nitelendirilen yerleri dolduruyoruz.
figure(5), imshow(bw);

[B,L] = bwboundaries(bw,'noholes');disp(B)
figure(6), imshow(label2rgb(L, @jet, [.5 .5 .5]))

hold on
for k = 1:length(B)
  boundary = B{k}; %'k' etiketindeki nesnenin sýnýr kordinatlarýný (X,Y) belirler;
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
fprintf('Nesneler iþaretlenmiþtir. Toplam Nesne Sayýsý=%d\n',k)

stats = regionprops(L,'Area','Centroid'); 

% Nesneleri sayan loopun baþlangýcý
for k = 1:length(B)
 
  % 'k' etiketindeki nesnenin sýnýr kordinatlarýný (X,Y) belirler
  boundary = B{k};
 
  % Nesnenin çevresini hesaplar
  delta_sq = diff(boundary).^2;
  perimeter = sum(sqrt(sum(delta_sq,2)));

  % 'k' etiketli nesnenin alanýný hesaplar
  area = stats(k).Area;
 
  % Nesnenin metric deðerini hesaplar
  metric = 4*pi*area/perimeter^2;
 
  % Hesaplanan deðeri gösterir
  metric_string = sprintf('%2.2f',metric);
  centroid = stats(k).Centroid;
 
  if metric > 0.9191  %Eðer metric deðer eþik deðerden daha büyük ise yuvarlak nesne kabul edilir.
    text(centroid(1),centroid(2),'Çember');
 
  elseif (metric <= 0.8693) && (metric >= 0.8241)
    text(centroid(1),centroid(2),'Dikdörgen');
  else
     text(centroid(1),centroid(2),'Belirlenemeyen Þekil');
  end
  
disp(metric)
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold');
  
end
fprintf('Nesneler iþaretlenmiþtir. Toplam Nesne Sayýsý=%d\n',k)