clc
clear all
close all
warning off

%reading host image
a=imread('lakshmi.jpeg');
subplot(2,2,1);
imshow(a);
title('Carrier Image');

%reading secret image
x=imread('lakshmi3.jpeg');
subplot(2,2,2);
imshow(x);
title('Secret Image');
[r c g]=size(a); %size of cover image
x=imresize(x,[r c]); %resizing secret image according to size of cover image

%separating RGB components of cover image
ra=a(:,:,1);
ga=a(:,:,2);
ba=a(:,:,3);

%finding RGB components of secret image
rx=x(:,:,1);
gx=x(:,:,2);
bx=x(:,:,3);

%EMBEDDING

%embedding red plane components
for i=1:r
    for j=1:c
       nc(i,j)= bitand(ra(i,j),254);
       ns(i,j)= bitand(rx(i,j),128);
       ds(i,j)=ns(i,j)/128;
       fr(i,j)=nc(i,j)+ds(i,j);
    end
end
redsteg=fr;

%embedding green plane components
for i=1:r
    for j=1:c
       nc(i,j)= bitand(ga(i,j),254);
       ns(i,j)= bitand(gx(i,j),128);
       ds(i,j)=ns(i,j)/128;
       fr(i,j)=nc(i,j)+ds(i,j);
    end
end
greensteg=fr;

%embedding blue plane components
for i=1:r
    for j=1:c
       nc(i,j)= bitand(ba(i,j),254);
       ns(i,j)= bitand(bx(i,j),128);
       ds(i,j)=ns(i,j)/128;
       fr(i,j)=nc(i,j)+ds(i,j);
    end
end
bluesteg=fr;

%concatenating RGB components
finalsteg=cat(3,redsteg,greensteg,bluesteg);
redstegr=finalsteg(:,:,1);
greenstegr=finalsteg(:,:,2);
bluestegr=finalsteg(:,:,3);
subplot(2,2,3);
imshow(finalsteg);
title('watermarked Image');
imwrite(finalsteg,'stegoimg.jpeg','jpeg');


%watermark extraction

%recovering red plane componenet
for i=1:r
    for j=1:c
        nc(i,j)=bitand(redstegr(i,j),1);
        ms(i,j)=nc(i,j)*128;
    end
end
recoveredr=ms;

%recovering green componenet
for i=1:r
    for j=1:c
        nc(i,j)=bitand(greenstegr(i,j),1);
        ms(i,j)=nc(i,j)*128;
    end
end
recoveredg=ms;

%recovered blue component
for i=1:r
    for j=1:c
        nc(i,j)=bitand(bluestegr(i,j),1);
        ms(i,j)=nc(i,j)*128;
    end
end
recoveredb=ms;

%concatenating three components
output=cat(3,recoveredr,recoveredg,recoveredb);
imwrite(output,'output.jpeg','jpeg');
subplot(2,2,4);
imshow(output);
title('Recovered Image');
