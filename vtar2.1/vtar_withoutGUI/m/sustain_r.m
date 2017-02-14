clear all ; close all ;
subject ={'MT : ', 'JM : '}
Num = 2 ; 
if(Num==1)

    Fn_1(:,:, 1) = [465 344 384 425 ;
        1174 1255 1134 1154 ;
        1518 1559 1316 1356 ;
        2774 2632 2754 2754 ;
        4253 4334 4151 4496 ;
        ] ;
    Fn_1(:,:, 2) = [486 384 425 405 ;
        1174 1316 1174 1012 ;
        1336 1498 1397 1356 ;
        2693 2673 2713 2693 ;
        4415 4273 4354 4475 ;
        ] ;

    % avg , upright vs. supine
    Fn_up = mean(Fn_1(:,:, 1), 2) ;
    Fn_su = mean(Fn_1(:,:, 2), 2) ;
    Fn_3d = [400 1360 1600 2920 4300 ]' ;
    %Fn_tube = [480 1100 1550 3070 3800]' ;

    Fn_tube = [381 1251 1551 2901 4161 ]' ;
    Fn_tubeRad = [366 1091 1536 2901 4156]' ;
    Fn_simp = [416 1276 1606 2841 4056 ]' ;
    Fn_simpRad = [ 401 1141 1576 2836 4031]' ;
    Fn_Mark = [496 1571 1851 3096 3781]' ;
    Fn_MarkRad = [476 1406 1756 3091 3781]' ;
else
    Fn_1(:,:, 1) = [344, 344, 425 364;
        992 1458 1215 729 ;
        1275 1802 1478 1275 ;
        3362 2997 3240 3179 ;
        3969 4030 3929 3908 ] ;
    Fn_1(:,:, 2) = [ 384 425 445 384;
        870 1113 1215 668 ;
        1154 1316 1417 1498 ;
        3503 3422 3260 2916;
        3989 3908 3868 3686 ; ] ;

    % avg , upright vs. supine
    Fn_up = mean(Fn_1(:,:, 1), 2) ;
    Fn_su = mean(Fn_1(:,:, 2), 2) ;
    Fn_3d = [520 1180 1690 3300 4000]' ;
    %Fn_tube = [480 1100 1550 3070 3800]' ;
    Fn_tube = [476 1096 1546 3076 3796]' ;
    Fn_tubeRad = [456 951 1521 3056 3771]' ;
    Fn_simp = [486 1136 1606 2941 3746]' ;
    Fn_simpRad = [ 466  996 1576 2916 3716]' ;
    Fn_Mark = [406 1341 1616 3291 4461]' ;
    Fn_MarkRad = [396 1181 1511 3286 4401]' ;

end
legendString = 'Best' ; 
data_sum = [Fn_1(:,:, 1),Fn_up, Fn_1(:,:, 2),Fn_su, 0.5*(Fn_su+Fn_up) ]
figure; bar([mean(Fn_1(:,:, 1), 2), mean(Fn_1(:,:, 2), 2)] ) ; grid on
legend('upright avg', 'supine  avg', 'Location', legendString) ;
title([subject{Num} 'formant avg. ']);
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
saveas(gcf, ['formant_avg' subject{Num}(1:2) ], 'jpg') ; 

figure; bar(Fn_1(:,:, 1) ) ; grid on
title([subject{Num} 'upright']);
legend('r as in poor', 'r as in read', 'r as in right', 'r as in role', 'Location', legendString) ;
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
% saveas(gcf, ['upright_' subject{Num}(1:2) ], 'jpg') ; 
figure; bar([Fn_1(:,:, 1) Fn_up] ) ; grid on
title([subject{Num} 'upright']);
legend('r as in poor', 'r as in read', 'r as in right', 'r as in role', 'avg', 'Location', legendString) ;
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
saveas(gcf, ['upright_' subject{Num}(1:2) ], 'jpg') ; 

figure; bar(Fn_1(:,:, 2) ) ; grid on
title([subject{Num} 'supine']);
legend('r as in poor', 'r as in read', 'r as in right', 'r as in role', 'Location', legendString) ;
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
figure; bar([Fn_1(:,:, 2) Fn_su]) ; grid on
title([subject{Num} 'supine']);
legend('r as in poor', 'r as in read', 'r as in right', 'r as in role', 'avg', 'Location', legendString) ;
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
saveas(gcf, ['supine_' subject{Num}(1:2) ], 'jpg') ; 

figure; bar([Fn_up Fn_su Fn_3d Fn_tube Fn_simp Fn_Mark] ) ; grid on
legend('upright avg', 'supine  avg', '3d fem', 'area function', 'simple tubes', 'AF from Mark', 'Location', legendString)
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
title([subject{Num}])
saveas(gcf, ['avg_Noradition_' subject{Num}(1:2) ], 'jpg') ; 

figure; bar([Fn_up Fn_su Fn_3d Fn_tubeRad Fn_simpRad Fn_MarkRad] ) ; grid on
legend('upright avg', 'supine  avg', '3d fem', 'area function', 'simple tubes', 'AF from Mark', 'Location', legendString)
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
title([subject{Num} 'Radiation effect included '])
saveas(gcf, ['avg_radition_' subject{Num}(1:2) ], 'jpg') ; 

figure; bar([Fn_1(:,1, 1) Fn_1(:,1, 2) Fn_3d Fn_tubeRad Fn_simpRad Fn_MarkRad] ) ; grid on
legend('upright r as in poor', 'supine  r as in poor', '3d fem', 'area function', 'simple tubes', 'AF from Mark', 'Location', legendString)
ylabel('Hz') ;
set(gca,'XTickLabel',{'F1';'F2';'F3';'F4';'F5'})
title([subject{Num} 'Radiation effect included '])
saveas(gcf, ['Poor_Radition_' subject{Num}(1:2) ], 'jpg') ; 
