{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00760') }},
        {{ ref('model_01114') }},
        {{ ref('model_00974') }}
)
select id, 'model_01863' as name from sources
