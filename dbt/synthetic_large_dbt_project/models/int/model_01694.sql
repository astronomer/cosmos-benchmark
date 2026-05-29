{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01154') }},
        {{ ref('model_01188') }},
        {{ ref('model_00873') }}
)
select id, 'model_01694' as name from sources
