{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01889') }},
        {{ ref('model_01523') }},
        {{ ref('model_02054') }}
)
select id, 'model_02743' as name from sources
