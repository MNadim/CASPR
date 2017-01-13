% Represents the kinematics and dynamics of a single cable segment
% 
% Author        : Darwin LAU
% Created       : 2011
% Description	:
%   Cable segments are fundamental for MCDMs since cables can pass through
%   multiple links and hence have multiple segments.
classdef CableSegmentModel < handle   
    properties (SetAccess = private)
        numLinks        = -1            % The number of links
        attachments     = {}            % CEll array of two attachment locations (index 1 is the "from", index 2 is the "to")
        CRM             = []            % Cable Routing Matrix for this cable and segment
    end
        
    properties (Dependent)
        segmentVector                   % vector \mathbf{l}_{ij} in frame {0}
        length                          % length of segment
        length_offset                   % offset length that is in addition to the point to point segment depending on the attachment type (typically 0)
    end
        
    methods
        function ck = CableSegmentModel(attachment_s, attachment_e, numLinks)
            ck.numLinks = numLinks;
            ck.CRM = zeros(1, numLinks+1);
            ck.attachments{1} = attachment_s;
            ck.attachments{2} = attachment_e;
            ck.CRM(attachment_s.link_num+1) = -1;
            ck.CRM(attachment_e.link_num+1) = 1;
        end
        
        function c_k = getCRMTerm(obj, k)
            CASPR_log.Assert(k(length(k)) <= obj.numLinks+1, 'Invalid link number.');
            c_k = obj.CRM(k);
        end
        
        % NOT SURE HOW THIS IS USED YET, but just a demo of what can be
        % done
        function clear(obj)
            obj.CRM = zeros(1, obj.numLinks+1);
            obj.attachments = {};
        end
        
        % The vectors r_OA are all in base frame
        function value = get.segmentVector(obj)
            value = obj.attachments{2}.r_OA - obj.attachments{1}.r_OA; 
        end
        
        function value = get.length(obj)
            value = sqrt(sum(obj.segmentVector.^2));
        end
        
        function value = get.length_offset(obj)
            % Only get the offset from the first attachment for now, unless
            % in the future the last segment also needs the second
            % attachment length_offset
            value = obj.attachments{1}.length_offset;
        end
    end
    
end