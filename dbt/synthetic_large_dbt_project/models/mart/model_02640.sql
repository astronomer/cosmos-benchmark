{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02063') }},
        {{ ref('model_01569') }}
)
select id, 'model_02640' as name from sources
