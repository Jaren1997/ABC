function BestChart = ABC_func(fhd,param,Lb,Ub,dim,funcNum)
format short e
% make copies of parameters
NGen = param.NGen;             % Maximum Number of Iterations
NP = param.NP;                 % Population Size
nOnlooker = param.nOnlooker;   % Number of Onlooker Bees
L = param.L;                   % Abandonment Limit Parameter (Trial Limit)
a = param.a;                   % Acceleration Coefficient Upper Bound

% Abandonment Counter
C=zeros(NP,1);

pop = Lb+(Ub-Lb).*rand(NP,dim);

for j = 1:NP
    fitness(j,1) = feval(fhd,pop(j,:),funcNum);
end

[best , bestX]=min(fitness);      % minimization
Fbest=best;Xbest=pop(bestX,:);
BestChart = [];
BestChart=[BestChart; Fbest];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for it=2:NGen      
    % Recruited Bees
    for j=1:NP        
        % Choose k randomly, not equal to i
        K=[1:j-1 j+1:NP];
        k=K(randi([1 numel(K)]));        
        % Define Acceleration Coeff.
        phi=a*unifrnd(-1,+1,1,dim);        
        % New Bee Position
        newbee = pop(j,:)+phi.*(pop(j,:)-pop(k,:));
%         Tp=newbee>Ub;
%         Tm=newbee<Lb;
%         newbee=(newbee.*(~(Tp+Tm)))+((rand(1,dim).*(Ub-Lb)+Lb).*(Tp+Tm));       
        % Evaluation
        newbee_cost= feval(fhd,newbee,funcNum);        
        % Comparision
        if newbee_cost<=fitness(j)
            pop(j,:)=newbee;
            fitness(j) = newbee_cost;
        else
            C(j)=C(j)+1;
        end       
    end
    
    % Calculate Fitness Values and Selection Probabilities
    F=zeros(NP,1);
    MeanCost = mean(fitness);
    for j=1:NP
        F(j) = exp(-fitness(j)/MeanCost); % Convert Cost to Fitness
    end
    P=F/sum(F);
    
    % Onlooker Bees
    for m=1:nOnlooker        
        % Select Source Site
        j=RouletteWheelSelection(P);        
        % Choose k randomly, not equal to i
        K=[1:j-1 j+1:NP];
        k=K(randi([1 numel(K)]));       
        % Define Acceleration Coeff.
        phi=a*unifrnd(-1,+1,1,dim);        
        % New Bee Position
        newbee=pop(j,:)+phi.*(pop(j,:)-pop(k,:));
%         Tp=newbee>Ub;
%         Tm=newbee<Lb;
%         newbee=(newbee.*(~(Tp+Tm)))+((rand(1,dim).*(Ub-Lb)+Lb).*(Tp+Tm));       
        % Evaluation
        newbee_cost= feval(fhd,newbee,funcNum);    
        % Comparision
        if newbee_cost<=fitness(j)
            pop(j,:) = newbee;
            fitness(j) = newbee_cost;
        else
            C(j)=C(j)+1;
        end       
    end
    
    % Scout Bees
    for j=1:NP
        if C(j)>=L
            pop(j,:)=unifrnd(Lb,Ub,1,dim);
            fitness(j)=feval(fhd,pop(j,:),funcNum);
            C(j)=0;
        end
    end    
    % Update Best Solution Ever Found
    [best,bestX]=min(fitness);      % minimization
    if best<=Fbest
       Fbest=best;
       Xbest=pop(bestX,:);
    end
    BestChart=[BestChart; Fbest];
end %iteration
