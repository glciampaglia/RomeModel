function varargout = null(varargin)
% Evento nullo. 
%
% Questa funzione serve per passare un aggiornamento che non fa
% nulla in fase di bootstrap al modello.
%
% NOTA: che varargin mi serve perché in poisson.m gli passo in automatico
% cella e decisione. Idem per varargout.
%
% See also BOOTSTRAP

varargout = {{}};