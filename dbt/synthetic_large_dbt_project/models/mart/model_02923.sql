{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02065') }},
        {{ ref('model_01585') }},
        {{ ref('model_01847') }}
)
select id, 'model_02923' as name from sources
