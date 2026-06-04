{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01550') }},
        {{ ref('model_01502') }},
        {{ ref('model_02177') }}
)
select id, 'model_02936' as name from sources
