%˵��������ƵĹ��ܣ����벦��������Ƶ��ͨ���б�ͬƵ��ʶ��������֡���ʾ����
      %ȱ���ɸĽ�֮����1�����б��������ͨ����ֵ������0.008�����Ը�Ϊ����Ӧ��
                      % 2��������Ƴ�GUI�汾���������������ʾ���˻���������г�� 
                      %һЩ����������ʹ�ò����淶����������Ȳ���������ṹ�����⣬�Լ�˼·�ϵ����⣬�����Խ�һ���Ż���лл����������~
       %����ǰ���������ü���fdatool����FIR�˲�����Hd��Hd1.�ֱ��Ǵ�ͨ570��670��1500��1600������950,1000��1100��1150
                
%%���ԸĽ�֮������һ��GUI    guide
close all;
clear global Q
clear global P
clear global t1
%
% Record your voice for 6 seconds.   �ο�0
recObj = audiorecorder;  %Ĭ�ϴ��� 8000 Hz��8 λ��1 ͨ���� audiorecorder ����
disp('Start speaking.')
recordblocking(recObj, 6);   %����6��   �ڶ��棬�ĳ�gui�汾�������ð�ť
disp('End of Recording.');
% Play back the recording.
play(recObj);

% Store data in double-precision array.
myRecording = getaudiodata(recObj);

filename = 'audio\your_number.wav'; %�����ļ� create the audio file
audiowrite(filename,myRecording,8000); %д������ write the content into the file
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���˴洢��Ƶ���ٵ��á���Ȼֱ�ӵ��ø�¼�õ���Ƶ������Ҳ��һ��˼·
folder='I:\matlab2016a\bin\audio\'; %folder address
file=dir([folder '*.wav']);         %�˴����Զ�ȡ�����Ƶ�ļ�  �ο�1
file=[folder file.name];   
try 
    [y,Fs]=audioread(file);         %FsΪ8000
catch
    warning('No suppot for the format.δ�����ļ�')
end

%����ԭʼ������sound��wavplay
sound(y,Fs);%
%��ʾԭʼ��������ֵ
figure(1)
subplot(4,1,1);
plot(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��һ���ǻ� ��ʱ����Ҷ�任Ƶ��ͼ ��ͨ�ó���
fs=Fs;
N=length(y); %numh
n=0:N-1; t=n/fs;
x=y;         %numh
y1=fft(x,N);
mag=abs(y1);
f=n*fs/N;
subplot(4,1,2),plot(f,mag);
xlim([0,2500]);
xlabel('Frenquency/Hz');
ylabel('Amp');grid on;

%%%%%%%%%%%%%%%%%���������ĸ�����ĳһ�ε������Ƚϴ�˵����һ����ʱ��
[b,a]=tf(Hd);%�õ����ݺ���   ����˲���HdΪ������˹��ͨ�˲�����500Hz��600Hz,1700Hz,1800Hz fdatool
d=filter(b,a,x);  %�����˲�
[b,a]=tf(Hd1);%�õ����ݺ���   ����˲��� fdatool
d=filter(b,a,d);
subplot(4,1,3);
plot(d);
title('ԭʼ�ź��˲���');
xlabel('t');
ylabel('d');
grid on;

%%%%%%%%%%%%%%�˲����Ƶ��
fs=Fs;
y2=d;
N=length(y2); %numh
n=0:N-1;
t=n/fs;
x=y2; %numh
y1=fft(x,N);
mag=abs(y1);
f=n*fs/N;
subplot(4,1,4);
plot(f,mag);
xlim([0,2500]);
xlabel('Frenquency/Hz');
ylabel('Amp');
grid on;

global Q;

m=d;               %�����˵��������¸�ֵ
temp=m;
global P;
%
P(1)=0;
for i = 1 : 100     %����ֱ��绰����Ϊ11λ�������Ż����Զ�ʶ��������������
    num=find(abs(temp) >= 0.008);     %0.008������������������ֵ�ָ�ֵ����ϵͳ�йأ��д��Ľ����������ݾ���  �ο�2
    if isempty(num)==1 
        break; 
    end
    if i==1 
        Q(i)=num(1);
    else
        Q(i)=num(1)+Q(i-1)+1800;      %���»�ȡ��Ƶ��δ����������Ƶ���൱�ڽ�ȥ��֪����Ƶ���֡����ʣ���Ƶ�������еĺ�������
    end
    temp=m((Q(i)+1800):N);
end
P(1)=i-1;
% clear global Q;
%}

global t1;
k=0;
%%%% ��ÿһ�����ݽ��� ��ʱFFT
figure;
for i = 1:P(1)
fs=Fs;
k=k+1;
if (Q(i)+1400) > 48000  %��������洢���򣬾Ͳ��ڼ�Ⲧ����
    break;
end
y3=d(Q(i)-50:Q(i)+1300);     %ע�ⰴ������ʱ�䡣������1500���ȵĹ�ϵ
N=length(y3)+200; %numh,fft���ȶ�+200
n=0:N-1;
t=n/fs;
x=y3; %numh
y4=fft(x,N);
mag1=abs(y4);
f=n*fs/N;
sum1(i)=sum(mag1.^2);
 
if sum(mag1.^2)<= 20;
    k=k-1;
    continue;
end
num10= 126.01+find ( mag1(128:194)  == max(mag1(128:194)));       %�ҵ���Ƶ���ֵķ�ֵ������126=650/��fs/N��;   194=1000/��fs/N��
num20= 193.8+find ( mag1(195:287)  == max(mag1(195:287)));     %�ҵ���Ƶ���ֵķ�ֵ������ 316=1485/��fs/N��
    num1=num10*fs/N;   %������ת���ɶ�Ӧ��Ƶ��
    num2=num20*fs/N;   
        
    if(689<=num1 && num1<=705)   %���·�Χ��8
         row=1;
    elseif (778>=num1 && num1>=762) 
         row=2;
    elseif (845<=num1 && num1<=860)
         row=3;
    elseif (933<=num1 && num1<=949)
         row=4;
    else
        k=k-1;
        continue;
    end 
    
    if(1201<num2 && num2<1217) 
       column=1;
    elseif (1344>=num2 && num2>=1328) 
       column=2;
    elseif (1469<=num2 && num2<=1485)  
       column=3;
    elseif (1625<=num2 && num2<=1641)
        column=4;
    else
        k=k-1;
        continue;   
    end 
    
 subplot(fix(P(1)/4)+1,4,k);%


 plot(f,mag1);
 xlim([500,2500])
 xlabel('Frenquency/Hz');
 ylabel('Amp');grid on;

 if  row==1 && column == 1   %�������еĵ绰������б�
         tel = 1;
     elseif row==1 && column == 2
         tel = 2;
     elseif row==1 && column == 3
         tel = 3;
     elseif row==2 && column == 1
         tel = 4;
     elseif row==2 && column == 2
         tel = 5;
     elseif row==2 && column == 3
         tel = 6;
     elseif row==3 && column == 1
         tel = 7;
     elseif row==3 && column == 2
         tel = 8; 
     elseif row==3 && column == 3
         tel = 9;
     elseif row==4 && column == 2
         tel = 0;  
     elseif row==4 && column == 3
         tel = '#'; 
     elseif row==4 && column == 1
         tel = '*';     
     else break;
 end 
t1(k)=tel;
end
disp('��������ĵ绰�����ǣ�');
disp(t1);

%�ο�0 blog�� https://ww2.mathworks.cn/help/matlab/ref/audiorecorder.html;jsessionid=d7ce1aa184bb7506b07ecde67dcb
%�ο�1 blog�� https://www.cnblogs.com/ksw2024/p/4488412.html
%�ο�2 blog�� https://blog.csdn.net/zhouyusong/article/details/8916729