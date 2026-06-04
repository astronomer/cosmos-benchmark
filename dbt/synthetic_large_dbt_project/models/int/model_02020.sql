{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01141') }},
        {{ ref('model_01499') }},
        {{ ref('model_01182') }}
)
select id, 'model_02020' as name from sources
