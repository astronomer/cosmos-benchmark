{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00262') }},
        {{ ref('model_00074') }},
        {{ ref('model_00097') }}
)
select id, 'model_01465' as name from sources
