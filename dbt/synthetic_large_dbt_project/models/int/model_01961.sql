{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01364') }},
        {{ ref('model_01075') }},
        {{ ref('model_01093') }}
)
select id, 'model_01961' as name from sources
