% Proposal Aim1 Figure
function EigenValueUniform(datapath,iTrial)
%% load data
%datapath = 'C:\Users\golde\Documents\Research\data\200922_11_58_\';
data1 = load([datapath,'results.mat']);
data1.param = load([datapath,'param.mat']);
%% Eigenvalues
% N = data1.param.N;
% Mneg = data1.param.MEI / (data1.param.MEI + eye(N)) * data1.param.MIE; 
% Nt = data1.param.nTrial;
%     Vs = zeros(N,N,Nt); Ds = zeros(N,Nt);
%     for ii = 1:Nt
%         it = ii;
%         [V,D] = sorteigs(diag(data1.g_readout(:,it))* (data1.MEEt(:,:,it)-Mneg) );
%         Vs(:,:,ii) = V;
%         Ds(:,ii) = diag(D);
%     end
%     save([datapath,'eigs_gMNet.mat'],'Vs','Ds')
data1.eigs = load([datapath,'eigs_gMNet.mat']);


v1 = real(data1.eigs.Vs(:,1,iTrial)');
v3 = real(data1.eigs.Vs(:,3,iTrial)');
v5 = real(data1.eigs.Vs(:,5,iTrial)');

fig = figure;

cs = summer(4);
ce0 = cs(3,:);ce1=cs(2,:);ce2=cs(1,:);


l1=plot(v1,'Color',ce0);hold on
l2=plot(v3,'Color',ce1);
l3=plot(v5,'Color',ce2);
xlabel('\theta')
lg = legend('1st','3rd','5th');
ylabel('real(v)')

saveas(fig, [datapath 'eigenvecNet',num2str(iTrial),'.jpg'])
saveas(fig, [datapath 'eigenvecNet',num2str(iTrial),'.fig'])
