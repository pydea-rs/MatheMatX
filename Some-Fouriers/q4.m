radius = sqrt(8); 
center_x = -2; 
center_y = 0;

theta=linspace(0,360); 
x=center_x+radius*cosd(theta); 
y=center_y+radius*sind(theta);

z=x+y*sqrt(-1);
w=ones(size(z))./z;

subplot(121);
plot(x,y);
title('دایره اصلی');
grid on;

subplot(122);
plot(real(w),imag(w));
title('نقاط تبدیل شده تحت w=1/z');
grid on;
