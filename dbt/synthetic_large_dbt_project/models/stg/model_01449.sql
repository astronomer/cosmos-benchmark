{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00560') }},
        {{ ref('model_00334') }},
        {{ ref('model_00464') }}
)
select id, 'model_01449' as name from sources
