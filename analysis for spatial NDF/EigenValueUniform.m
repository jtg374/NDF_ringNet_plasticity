% Proposal Aim1 Figure
function EigenValueUniform(datapath)
%% load data
%datapath = 'C:\Users\golde\Documents\Research\data\200922_11_58_\';
data1 = load([datapath,'results.mat']);
data1.param = load([datapath,'param.mat']);
%% Eigenvalues
N = data1.param.N;
Nt = data1.param.nTrial;
    Vs = zeros(N,N,Nt); Ds = zeros(N,Nt);
    for ii = 1:Nt
        it = ii;
        [V,D] = sorteigs(diag(data1.g_readout(:,it))*data1.MEEt(:,:,it));
        Vs(:,:,ii) = V;
        Ds(:,ii) = diag(D);
    end
    save([datapath,'eigs_gMEE.mat'],'Vs','Ds')
data1.eigs = load([datapath,'eigs_gMEE.mat']);

[~,D_EI] = sorteigs(data1.param.MEI);
[~,D_II] = sorteigs(data1.param.MII);
[~,D_IE] = sorteigs(data1.param.MIE);
D_neg = diag(D_EI/D_II*D_IE);
d1 = real(data1.eigs.Ds(1,:)')/D_neg(1);
d3 = real(data1.eigs.Ds(3,:)')/D_neg(3);
d5 = real(data1.eigs.Ds(5,:)')/D_neg(5);

fig = figure;

cs = summer(4);
ce0 = cs(3,:);ce1=cs(2,:);ce2=cs(1,:);


l1=plot(d1,'Color',ce0);hold on
l2=plot(d3,'Color',ce1);
l3=plot(d5,'Color',ce2);
xlabel('Trial')
lg = legend('1st','3rd','5th');
ylabel('(\lambda_{EE}\lambda_{II})/(\lambda_{EI}\lambda_{IE})')

saveas(fig, [datapath 'eigenvalues.jpg'])
saveas(fig, [datapath 'eigenvalues.fig'])
saveas(fig, [datapath 'eigenvalues.pdf'])
