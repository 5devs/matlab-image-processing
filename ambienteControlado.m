% ambiente controlado

% Fecha todas as janelas
close all;

%controle
numpixels = 1730 * 1730; % 900 cm²
AreaImagem = 900;

% le a imagem
feijao = imread('imgs/controlado.jpg');
feijao2 = imread('imgs/feijao2.jpg');

% transforma a imagem em tom de cina
feijao_a = rgb2gray(feijao);

% figure, imhist(feijao_a)

% faz o Thresholding
feijao_t = feijao_a < 250;

% conta o numero de feijões e rotula numericamente cada um
% deles
[feijaorot,numObjetos] = bwlabel(feijao_t,4);

% imagem pseudo_color
pseudo_color = label2rgb(feijaorot, @spring, 'c', 'shuffle');

% regionprops(), que retornará em uma
% estrutura, a área (em pixels), o centro de massa e o retângulo que envolve
% (bounding box) cada um dos componentes.
feijao_dados = regionprops(feijaorot,'basic');

% pega o maior feijao
tamanhoMaximo = max([feijao_dados.Area]);

% pega o menor feijao
tamanhoMinimo = min([feijao_dados.Area]);

% media de tamanhos
tamanhoMedio = int32(median([feijao_dados.Area]));

AcimaDaMedia = 0;
AbaixoDaMedia = 0;

% Coloca os numeros dos elementos
for i = 1:numObjetos
   feijao2 = insertText(feijao2,feijao_dados(i).Centroid ,i,'BoxOpacity',0.4); 
   if(feijao_dados(i).Area < tamanhoMedio)
       AbaixoDaMedia = AbaixoDaMedia + 1;
   else
        AcimaDaMedia = AcimaDaMedia + 1;
    end
end

msg = sprintf('Foram Encontrados: %d feijoes.', numObjetos);
feijao2 = insertText(feijao2,[1 1],msg,'BoxColor','yellow','BoxOpacity',0.4); 

msg = sprintf('Maior Feijao: %f cm2.', double(tamanhoMaximo * AreaImagem / numpixels));
feijao2 = insertText(feijao2,[1 22],msg,'BoxColor','green','BoxOpacity',0.4); 

msg = sprintf('Menor Feijao: %f cm2.', double(tamanhoMinimo * AreaImagem / numpixels));
feijao2 = insertText(feijao2,[1 44],msg,'BoxColor','blue','BoxOpacity',0.4); 

msg = sprintf('Media do Feijao: %f cm2.', double(tamanhoMedio * AreaImagem / numpixels));
feijao2 = insertText(feijao2,[1 66],msg,'BoxColor','magenta','BoxOpacity',0.4); 

msg = sprintf('Acima da Media: %d un.', AcimaDaMedia);
feijao2 = insertText(feijao2,[1 88],msg,'BoxColor','yellow','BoxOpacity',0.4); 

msg = sprintf('Abaixo da Media: %d un.', AbaixoDaMedia);
feijao2 = insertText(feijao2,[1 110],msg,'BoxColor','red','BoxOpacity',0.4); 

% resultado final
figure,
imshow(feijao2),
for i = 1:numObjetos
    if feijao_dados(i).Area == tamanhoMaximo
        cor = 'g';
    else if feijao_dados(i).Area == tamanhoMinimo
            cor = 'b';
         else if feijao_dados(i).Area < tamanhoMedio
            cor = 'r';
             else
                 cor = 'y';
             end
         end
    end
    rectangle('Position',feijao_dados(i).BoundingBox, 'EdgeColor',cor, 'LineWidth', 1),
end %end for