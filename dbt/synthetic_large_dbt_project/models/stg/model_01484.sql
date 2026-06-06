{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00582') }},
        {{ ref('model_00132') }},
        {{ ref('model_00216') }}
)
select id, 'model_01484' as name from sources
