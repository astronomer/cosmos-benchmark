{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01280') }},
        {{ ref('model_01221') }}
)
select id, 'model_02058' as name from sources
