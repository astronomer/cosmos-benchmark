{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01535') }},
        {{ ref('model_01830') }}
)
select id, 'model_02688' as name from sources
