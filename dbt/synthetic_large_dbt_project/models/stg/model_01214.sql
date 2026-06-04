{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00464') }},
        {{ ref('model_00499') }}
)
select id, 'model_01214' as name from sources
