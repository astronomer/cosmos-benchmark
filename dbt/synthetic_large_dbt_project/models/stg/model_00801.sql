{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00057') }},
        {{ ref('model_00224') }},
        {{ ref('model_00589') }}
)
select id, 'model_00801' as name from sources
