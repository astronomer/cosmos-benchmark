{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00559') }},
        {{ ref('model_00251') }},
        {{ ref('model_00154') }}
)
select id, 'model_00775' as name from sources
